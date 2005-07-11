From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: Defeating NMAP Null scans (and Nessus scans).
Date: Mon, 11 Jul 2005 23:59:22 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0507112228330.30372@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


>>    -j REJECT -m random --average 15
>>    -j DROP
>>The REJECT/DROP mix confuses nmap more than a plain DROP.
>Interesting this use of random. 

For the record,
I have also tried this, which yields the same results (on -T Insane at least):

    -j REJECT -m dstlimit --dstlimit 1/sec --dstlimit-mode srcip-dstip
    -j DROP

I've just wrote a short (well, already at 10K) tech doc for the implementation 
of (parts of) AS_IPFW, including the nmap null scans. It is kept generic, so 
can be used for any self-baked script.
http://alphagate.hopto.org/AS_IPFW/ , in the tarball a file "TECH".



Jan Engelhardt
-- 
