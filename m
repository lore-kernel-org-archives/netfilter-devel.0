From: Giacomo <delleceste@gmail.com>
Subject: A question about passing structs between kernel functions
Date: Sat, 21 Feb 2009 10:47:46 +0100
Message-ID: <885896af0902210147q1650e008t689628678d2cc648@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:22252 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbZBUJrt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Feb 2009 04:47:49 -0500
Received: by nf-out-0910.google.com with SMTP id d21so173344nfb.21
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Feb 2009 01:47:47 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Good morning to all.
Yesterday, talking with Jan about an issue that happened to me some time ago,
I would like to submit the question to your attention, to go deeper
into the problem.

Context details:
1. kernel module registered with netfilter hooks that takes the socket buffer
    reads it and sends a verdict after consulting a ruleset.
2. the ruleset is a linked list of rules which is given to the kernel
via netlink
    socket.

- struct command contains the rule to pass to kernel space:

struct command
{
       short cmd;              /* command type */

        union{
        ipfire_rule rule;
        struct firesizes fwsizes;
        }content;

        int anumber;            /* a number reserved for some cmd values */

        /* .... other fields */
}

this command struct is about 800 bytes large and ipfire_rule structure
(which you
can see inside content union) contains integers and arrays of
integers, for instance

struct ipfire_rule
{
  int a, b, c;
  __u32 srcaddress[50];
  __u32 dstaddress[50];
   ......
}

this programming pattern was causing serious problems:

int f()
{
  struct command cmd;
  /* modify cmd ... */
  return g(&cmd);

}

int g(struct command *com)
{
  com->a = 2;
  /* .... and so on modify  com */
 return h(com);
}

int h(struct command *com)
{
   com->a  = 3; /* for example */
   /* here in particular I copy com into a socket buffer and send
    * the skb via netlink socket.
    */
   return 0; /* returns to f() */
}

This pattern caused reproducible kernel panics, with many different messages
each time (NULL Pointer dereference, scheduling while atomic, or
nothing.. just hang)

The following pattern solved:

int f()
{
  int ret;
  struct command *cmd;
  cmd = kmalloc(sizeof(struct command), GFP_ATOMIC);
  ret = g(cmd);
  kfree(cmd);
  return ret;
}

The question is: has the first programming pattern something wrong in principle?
I know it hasn't in userspace, but in kernel, with preemption enabled
and inside the
context described?
Another detail: the first pattern used to work for a long time, until
the rule structure,
and so the command structure, grew in size, after the addition of

__u32 src_address[50]; /* and dst_address */

which before simply was

 __u32 src_address.


Or is the pattern perfectly allowed, and I have to look for some other bug?

Thanks in advance.
Giacomo.











-- 
Giacomo S.
http://www.giacomos.it

- - - - - - - - - - - - - - - - - - - - - -

* Aprile 2008: iqfire-wall, un progetto
  open source che implementa un
  filtro di pacchetti di rete per Linux,
  e` disponibile per il download qui:
  http://sourceforge.net/projects/ipfire-wall

* Informazioni e pagina web ufficiale:
  http://www.giacomos.it/iqfire/index.html

- - - - - - - - - - - - - - - - - - - - - -

 . ''  `.
:   :'    :
 `.  ` '
    `- Debian GNU/Linux -- The power of freedom
        http://www.debian.org
