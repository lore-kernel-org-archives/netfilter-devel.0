From: Kishore Dharmavaram <kishored@servgate.com>
Subject: RE: Memory leaks in ip_conntrack?
Date: Sat, 8 Nov 2003 19:08:13 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <EFBADA8C200C2B418DA39734FD15475B0B204A@skat.sky.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Cc: "'netfilter@lists.netfilter.org'" <netfilter@lists.netfilter.org>,
	"'netfilter-devel@lists.netfilter.org'"
	 <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: 'Harald Welte' <laforge@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Herald & All,

I verified & I find my 2.4.20 is already patched with UNCONFIRMED
connections fix. 

How it possible that /proc/slabinfo shows a lot more ip_conntracks than are
shown in "/proc/net/ip_conntrack"?. /proc/slabinfo shows that maximum
possible conntracks, 131072, are being currently used but
/proc/net/ip_conntrack  shows only 21 connections. My box is refusing new
connections because max conntracks have reached. 

Please take a look at my console output given below:

[root@Firewall root]# cat /proc/sys/net/ipv4/ip_conntrack_max
13072
[root@Firewall root]# cat /proc/slabinfo | fgrep ip_conn
ip_conntrack      131072 131080    384 13108 13108    1
[root@Firewall root]# cat /proc/net/ip_conntrack | wc -l
     21

Can anyone tell how to findout which connections are using up the
conntracks.

Thanks,
Kishore

-----Original Message-----
From: Harald Welte [mailto:laforge@netfilter.org]
Sent: Saturday, November 08, 2003 3:44 AM
To: Kishore Dharmavaram
Cc: 'netfilter@lists.netfilter.org';
'netfilter-devel@lists.netfilter.org'
Subject: Re: Memory leaks in ip_conntrack?


On Fri, Nov 07, 2003 at 02:21:13PM -0800, Kishore Dharmavaram wrote:
> Hi All,
> 
> I have a Linux box running 2.4.20 kernel with netfilter(ip_conntrack)

http://www.netfilter.org/security/2003-08-01-listadd.html

> Thanks,
> Kishore

-- 
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
============================================================================
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie
