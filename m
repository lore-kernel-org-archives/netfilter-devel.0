From: Pablo Neira <pablo@eurodev.net>
Subject: Re: patch for conntrack expectations
Date: Thu, 04 Mar 2004 01:12:35 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40467473.70404@eurodev.net>
References: <403014C5.8080102@eurodev.net> <20040217213217.GF30968@obroa-skai.de.gnumonks.org> <4032F4DE.3050402@eurodev.net> <20040218172539.GX9464@sunbeam.de.gnumonks.org> <4038B14C.901@eurodev.net> <20040224094014.GV13386@sunbeam.de.gnumonks.org> <403B1F5F.6010004@trash.net> <20040224102432.GX13386@sunbeam.de.gnumonks.org> <403B7CAA.3060005@trash.net> <403CD128.40101@eurodev.net> <404668EB.1080400@trash.net> <40466F35.3080709@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>,
 netfilter-devel@lists.netfilter.org
In-Reply-To: <40466F35.3080709@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi again Patrick,

Patrick McHardy wrote:

> Besides being what I would expect from
> an _alloc-function it helps gcc generate better code because
> it assumes comparisons with NULL unlikely to be true.

yes, I agree with you, thanks for the suggestion. I'll modify the 
current prototype.

thanks for the feedback,
Pablo
