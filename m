From: Michel Banguerski <Michel.Banguerski@laposte.net>
Subject: Syncookie firewall
Date: Sun, 02 Jun 2002 20:47:28 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <3CFA683F.50A4CDEE@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: frank.schafer@setuza.cz, netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hi Frank,
Hi all

I came across your posing on netfilter-dev of and i share your
opinion that it would be a cool feature for linux-based firewall.

I'd be glad to hear from you that you still want to implement
this and i'd like to participate.

As I didn't fond anything about your proposal being developped
in the list, i'll continue from this old one

Here are my ideas about to how to do it.

- This should be implemented as target/matching module to allow
people to select connections they want to protect with this feature.

- The modules we could use as examples are the REJECT target
because it generates a new packet and the CONNMARK target
because it stores data in the connection context. Window tracking
patch because it deals with SYN and ACK values.


Working principle(with variations):

0) we match the new incomming syn packet with conventional syntax

1) The COOKIE target will drop the incomming SYN packet and
    generate the reply synack packet with the cookie.
    usage: -j COOKIE --syn

2) The  cookie match module (-m cookie) or the extention of the
   state module (-m state --state COOKIE) will match the third packet
   of the handshake.

        Possible feature: several classes of cookies using different
        "salt" in the crypto funtion allowing following
        "-j COOKIE --syn --class xx" and then "-m cookie  --class xx yy"

        where xx is an integer and yy is a mask.  This feature would
        probabely require a separate matching module.
        Beware that lots of classes will weaken cookies.

3) The COOKIE --synack  target will register the connection and store
the
   cookie we sent (which came came back), we need this because the
server
   will answer with it's own ACK number that has to be incremented by
the
   cookie-offset. Then this same target will generate the syn packet
sent
   to the targeted server.

2)+3) usage:
    -m cookie --state SYN -j COOKIE --synack
or
    -m state --state COOKIE -j COOKIE --synack

4) Now we need either a couple of module/target  to match the synack
packet
   comming back from the server to send it back  the ack:
    -m cookie --state  SYNACK -j COOKIE --ack
  (and in this case the cookie module would get the option --syn in step
2).

  or extend the conntrack/ACCEPT code to do this silently and declare
the
  server's synack packet as established:
    -m state --state ESTABLISED -j ACCEPT (this one would be good for
                                performance, but see unanswered quetions
below)
  or
    -m state --state COOKIE2 -j COOKIE --ack

5) Remaining packets will need to fix their SYN/ACK values because of
the
   initial cookie. Again we need to decide between extending conntrack
   and creating dedicated match/target.
   Extending module would lead to simply have
       -m state --state ESTABLISED -j ACCEPT
   Using dedicated match/target
       -m cookie --state ACK  -j COOKIE --fix


Questions that i have no answered yet:
 -  What to do if the server is down

 -  How to avoid breaking nat

 -  How to handle the ACCEPT target if we extend conntrack code to
        deal with the third packet from the server and declare it
ESTABLISHED

 -  Is there a trick that could allow us to not to store context before
        receiving the third ack from the server

 -  What are good(clear) names for matches/targets options: the sequence

        (--syn), (SYN => --synack), (SYNACK => --ack), (ACK=> --fix)
        is logical, but may be misleading

 -  What are pitfalls i've missed.


Sorry for my poor english

Best regards,
Michel
