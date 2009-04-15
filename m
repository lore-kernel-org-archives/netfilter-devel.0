From: Giacomo <delleceste@gmail.com>
Subject: nlmsg_failure on a function in some machines
Date: Wed, 15 Apr 2009 22:53:24 +0200
Message-ID: <885896af0904151353r2c3fb13du9ce3ac524bf5ae9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:36441 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbZDOUx2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Apr 2009 16:53:28 -0400
Received: by ewy9 with SMTP id 9so94657ewy.37
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2009 13:53:25 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Good morning to all.
I noticed that the following piece of code, while working on many machines,
goes to NLMSG_PUT nlmsg_failure goto label in some cases.

Is there something wrong with it?

Thanks in advance.

Code follows here:

 /* buf is a buffer containing the data to be sent to userspace,
  * numbytes is the length of the data contained in buf
 */
 struct sk_buff *build_packet(void *buf, int numbytes)
    4 {
    5   struct sk_buff *skb_to_user;
    6   struct nlmsghdr *nlh;
    7   void *data;
    8   int len = NLMSG_SPACE(numbytes);
    9    /* allocate socket buffer space atomically */
   10   skb_to_user = alloc_skb(len, GFP_ATOMIC);
   11
   12   if(skb_to_user == NULL)
   13     return NULL;
   14
   15   nlh = NLMSG_PUT(skb_to_user, 0, 0, 0, len);
   16   if(NLMSG_OK(nlh, NLMSG_LENGTH(len)))
   17   {
   18     nlh->nlmsg_len = NLMSG_LENGTH(len);
   19     data = NLMSG_DATA(nlh);
   20     memcpy(data, buf, numbytes);
   21   }
   22   else
   23   {
   24     printk("IPFIRE: NLMSG_OK failed: NLMSG_LENGTH(%d) is %d,
NLMSG_SPACE(numbytes %d) is %d in build_packet(), "
   25       "ipfi_netl_packet_builder.c\n", len, NLMSG_LENGTH(len),
numbytes, NLMSG_SPACE(numbytes));
   26     return NULL;
   27   }
   28   return skb_to_user;      /* return just allocated socket buffer */
   29
   30   nlmsg_failure:  /* NLMSG_PUT fails */
   31
   32   printk("IPFIRE: nlmsg failure in build_packet() - %d bytes -
ipfi_netl_packet_builder.c\n", len);
   33   return NULL;
   34 }
   35

  As told before, in some machines NLMSG_PUT goes to nlmsg_failure label.

Thanks in advance for any suggestion.

Best regards

Giacomo


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
