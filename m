From: Patrick McHardy <kaber@trash.net>
Subject: Re: Bug with netfilter and NFS server on same machine (fwd)
Date: Fri, 06 Dec 2002 01:56:18 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DEFF5B2.1050106@trash.net>
References: <Pine.LNX.4.44.0211231342530.3237-100000@sparrow> <20021205202119.GH11068@naboo.club.berlin.ccc.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: William Stearns <wstearns@pobox.com>,
   ML-netfilter-devel <netfilter-devel@lists.netfilter.org>,
   Lars Knudsen <gandalfit@virgilio.it>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20021205202119.GH11068@naboo.club.berlin.ccc.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

Harald Welte wrote:

>On Sat, Nov 23, 2002 at 01:44:45PM -0500, William Stearns wrote:
>  
>
>>Good day, Lars,
>>	Whether or not the netfilter list was able to find an answer, it 
>>might still make sense to CC that list.
>>    
>>
>
>yup, definitely.
>
>  
>
>>The problem is this: A machine running linux 2.4.18 or 2.4.19 works just 
>>fine when running just the kernel nfsd. A single client connected to the 
>>server with 100Mbit ethernet sees throughput of 5-10MByte/sec even after 
>>an hour or two of continous transfers. If the nfs server is also running 
>>iptables the throughput is initially the same (5-10MByte/sec) but after 
>>a while (200MByte-500MByte total transfer) the client starts reporting 
>>"nfs server not responding" followed after a while by "nfs server OK" 
>>and of course the transfer rate goes way down (< 1MByte/sec). Using 
>>tcpdump on the client seems to indicate that some packets have their 
>>headers garbled - wrong fragment ids being the typical error.
>>    
>>
>
>this sounds like a problem with nfs's exceptionally large packet size
>(up to 8k) and the resulting udp fragments, which need to get
>defragmented and refragmented while conntrack is done.
>
I experienced the same problem since almost 6 months with nfs and netfilter,
nfs was veery slow, it wasn't even possible to listen to mp3s over nfs.
removing the conntrack module made it work normal again.
the client ringbuffers fills with
UDP: short packet: 192.168.0.1:55258 58191/236 to 192.168.0.23:55789
UDP: short packet: 192.168.0.1:12966 57456/236 to 192.168.0.23:1590
UDP: short packet: 192.168.0.1:41383 20796/236 to 192.168.0.23:32904
while conntrack module is loaded.
i placed a lot of printk's in conntrack and ip_fragment but couldn find 
any pointers
where the problem might be. interesting might be that changing the mtu 
of the
interface to 1486 works well, even with conntrack loaded .. while 
without conntrack 1500 is ok.

>
>Apart from that I don't have any idea.  I run lots of linux nfs servers
>on machines which have conntrack running, without ever encountering the
>problem you are describing.  There has to be something special about
>your setup(s) we are missing here.
>
>Any idea?
>
>Thanks.
>
>  
>
>>\Lars Knudsen
>>    
>>
>
>  
>
bye,
patrick
