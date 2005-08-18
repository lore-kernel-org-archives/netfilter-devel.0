From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: when I DNAT to local address, the port num seems to be strange.
Date: Thu, 18 Aug 2005 17:50:29 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0508181749390.1090@yvahk01.tjqt.qr>
References: <1124328975.2701.7.camel@cocteau.hellwolf-misty.org>
	<Pine.LNX.4.61.0508181040570.31007@yvahk01.tjqt.qr>
	<1124356395.5124.3.camel@cocteau.hellwolf-misty.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Hellwolf Misty <hellwolf@seu.edu.cn>
In-Reply-To: <1124356395.5124.3.camel@cocteau.hellwolf-misty.org>
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


>> If destination is 127.0.0.1, needs -j REDIRECT.
>> You can also use -j DNAT 192.168.1.1 (i.e. the eth0 addr)
>
>I've tried as you told: REDIRECT --to-ports 8888, or -j DNAT --to
>LOCALADDRESS, but it nothing changes. 

Make sure 8888 itself is not DROPped? I am not sure what's in the FC kernel, 
but should not be any different. Note that PREROUTING does NOT apply if
src==127.0.0.1! Currently, you only told us dst=127.0.0.1...



Jan Engelhardt
-- 
| Alphagate Systems, http://alphagate.hopto.org/
