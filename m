From: "Ricky Foo" <blue_pion@hotmail.com>
Subject: Re: ALGs
Date: Wed, 04 Jun 2003 07:06:30 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Sea2-F11MieZutGvO8n00003af5@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Good day,

Some doubts about the conntrack helper module.

1. For the "help" callback, what exactly am I suppose to do with the packets 
when this function is activated?

2. For the netbios protocol, there are a couple of ports to monitor, such as 
137 for name-service, 138 for datagram service, 139 for session service. 
Does that mean I have to write 3 different tracking modules or do I follow 
what has been done in the ftp module...i.e register the 3 different ports to 
track.

3. In the corresponding header files, what do we normally have to define for 
the various structure? I kinda got confused by what I have read from the 
source code!

4. How do I get to the payload part where the netbios data-fields are?

Please pardon me if my questions do seems silly to you guys.

    Ricky


----Original Message Follows----
From: Harald Welte <laforge@netfilter.org>
To: Ricky Foo <blue_pion@hotmail.com>
CC: netfilter-devel@lists.netfilter.org
Subject: Re: ALGs
Date: Tue, 3 Jun 2003 12:26:51 +0200

On Mon, Jun 02, 2003 at 11:08:42AM +0000, Ricky Foo wrote:
 > Hi guys,
 >
 > I am new to this list. Currently, I need to develop a ALG for netbios but 
i
 > can't seems to find the source-code anywhere in the kernel directory. Can
 > anybody lend a helping hand?

for examples see:
/usr/src/linux/net/ipv4/netfilter/ip_{conntrack,nat}_{ftp,irc}.c
/usr/src/linux/include/linux/netfilter_ipv4/ip_{conntrack,nat}_{ftp,irc}.h

please also note the newnat-summary.txt from CVS and the outdated
netfilter hacking howto - as well as lots of other conntrack/NAT helper
modules in patch-o-matic.

 > Hopefully I can contribute the code back when I am finished since
 > there aren't any ALG for netbios if I am not wrong.

No, there are none.  We're always happy about contributions.

 > Thanks.
 >    Ricky

--
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
============================================================================
   "Fragmentation is like classful addressing -- an interesting early
    architectural error that shows how much experimentation was going
    on while IP was being designed."                    -- Paul Vixie
<< attach3 >>

_________________________________________________________________
Send a fun phone greeting to your friend! 
http://www.msn.com.sg/mobile/fungreetings/
