From: Hellwolf Misty <hellwolf@seu.edu.cn>
Subject: Re: when I DNAT to local address, the port num seems to be strange.
Date: Thu, 18 Aug 2005 17:13:15 +0800
Message-ID: <1124356395.5124.3.camel@cocteau.hellwolf-misty.org>
References: <1124328975.2701.7.camel@cocteau.hellwolf-misty.org>
	<Pine.LNX.4.61.0508181040570.31007@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
In-Reply-To: <Pine.LNX.4.61.0508181040570.31007@yvahk01.tjqt.qr>
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

On Thu, 2005-08-18 at 10:41 +0200, Jan Engelhardt wrote:
> >Subject: when I DNAT to local address, the port num seems to be strange.
> 
> If destination is 127.0.0.1, needs -j REDIRECT.
> You can also use -j DNAT 192.168.1.1 (i.e. the eth0 addr)
> 
> 

I've tried as you told: REDIRECT --to-ports 8888, or -j DNAT --to
LOCALADDRESS, but it nothing changes. 


P.S:
$ uname -r
2.6.11-1.1369_FC4
