From: Patrick McHardy <kaber@trash.net>
Subject: Re: patch for conntrack expectations
Date: Tue, 24 Feb 2004 10:54:39 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <403B1F5F.6010004@trash.net>
References: <403014C5.8080102@eurodev.net> <20040217213217.GF30968@obroa-skai.de.gnumonks.org> <4032F4DE.3050402@eurodev.net> <20040218172539.GX9464@sunbeam.de.gnumonks.org> <4038B14C.901@eurodev.net> <20040224094014.GV13386@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira <pablo@eurodev.net>,  netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040224094014.GV13386@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:
> On Sun, Feb 22, 2004 at 02:40:28PM +0100, Pablo Neira wrote:
> 
>>- I saw that Patrick submitted recently a patch to clean up the amanda 
>>helper (BTW, nice work!), I tried to patch my kernel with his patch 
>>available in patch-o-matic but it failed. So I patched the current. I 
>>also have no problem about patching the new one.
> 
> 
> I thought this was included already in the stock kernel. At least in
> 2.4.x the patch went in.  Patrick, can you comment on this?

The 2.4 patch went in, the 2.6 didn't. Some of the problems got fixed
in 2.6 when removing skb_linearize, but some didn't. Do you want me to
resubmit the patch to you ?

Regards
Patrick
