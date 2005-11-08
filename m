From: Pablo Neira <pablo@netfilter.org>
Subject: Re: [PATCH 8/8] Add missing sizecheckings
Date: Tue, 08 Nov 2005 19:17:48 +0100
Message-ID: <4370EBCC.9040308@netfilter.org>
References: <43700324.5080505@netfilter.org> <4370B08B.30507@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4370B08B.30507@trash.net>
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

Patrick McHardy wrote:
> Pablo Neira wrote:
> 
>>Add missing sizecheckings. Thanks Patrick Mchardy for the hint. This
>>patch requires the previous (7/8), otherwise it would break ctnetlink.
> 
> 
> Both patches look good to me, although you probably should use
> size_t or unsigned int for the cta_.*_min arrays, otherwise
> I think gcc-4.x will complain.

yes, agreed. I'll resend this patch using size_t late at night.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
