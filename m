From: "Ricky Foo" <blue_pion@hotmail.com>
Subject: About netbios ALG
Date: Wed, 23 Jul 2003 01:32:05 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Sea2-F4696TwctPBjxP0000b6e9@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: song_wang@msn.com
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

>From what I know, NAT will block domain logon. You can refer to the 
following url for more details.

http://support.microsoft.com/default.aspx?scid=http://support.microsoft.com:80/support/kb/articles/q172/2/27.asp&NoWebContent=1

As for the windows folder sharing problem you have described, according to 
pkt sniffing, file transfers are done using Netbios session service, port 
139. Inside this layer, it does not carry the IP address of the source, thus 
it is unlikely that your NAT is causing a problem. (I could be wrong.... :-) 
but to my understanding why netbios can't work over NAT is because they 
don't do address translation in the application stack.)

Also, I am not done with the modules that I'm writing. Most of the codes are 
completed but there are some details that I am not sure and I have not fully 
tested them yet. If you are interested, I can pass them to you but the 
condition is that you must release them back to the Netfilter code base when 
you are done.

    Ricky


>From: "Song Wang" <song_wang@msn.com>
>To: blue_pion@hotmail.com
>Subject: About netbios ALG
>Date: Tue, 22 Jul 2003 12:19:15 -0700
>
>Hi, Ricky
>
>I found your email address on the netfilter mailing list when you were 
>talking about
>netbios ALGs
>
>I found a problem with netbios when 2 Windows PCs behind a NAT router
>try to access the same shared directory on the Windows server sitting on 
>the
>other side of the NAT router. (kernel 2.4.17 w/ iptables 1.2.7a)
>
>For example
>
>4.3.2.1--------<NAT router>---------PC1 192.168.1.2
>                                       |-------PC2 192.168.1.3
>
>Windows XP PC1 and PC2 got private IP address from the DHCP server
>on the NAT router.When PC1 alone accesses the shared directory on the
>Windows XP server (or PC) 4.3.2.1 using \\4.3.2.1, there is no problem.
>However, when PC2 also accesses the same directory via \\4.3.2.1, problem 
>arises.
>You can reproduce the problem in this way
>
>Copy a file from \\4.3.2.1 to PC1, when the copying is ongoing, do a 
>refresh (F5) or
>copy a file on the same \\4.3.2.1 from PC2, you will see a dialog pop up on 
>PC1
>
>"The specified network name is not available"
>
>The copying process got stuck.
>
>Strangely, the problem seems to happen only when the two PC get the IP 
>address
>via DHCP. If one of the two PCs use the static IP address, the problem 
>seems to go away.
>
>Could this be a problem of netbios with connection tracking? Maybe we need 
>to write
>a nat helper module for netbios?
>
>Do you have insight on what the problem is? Any progress on your netbios 
>ALG?
>
>Thanks.
>
>-Song
>
>_________________________________________________________________
>STOP MORE SPAM with the new MSN 8 and get 2 months FREE*  
>http://join.msn.com/?page=features/junkmail
>

_________________________________________________________________
Download Norah Jones, Eminem and more! http://www.msn.com.sg/ringtones/ at 
only S$36 including GST
