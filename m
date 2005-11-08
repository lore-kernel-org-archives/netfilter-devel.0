From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 8/8] Add missing sizecheckings
Date: Tue, 08 Nov 2005 15:04:59 +0100
Message-ID: <4370B08B.30507@trash.net>
References: <43700324.5080505@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@netfilter.org>
In-Reply-To: <43700324.5080505@netfilter.org>
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

Pablo Neira wrote:
> Add missing sizecheckings. Thanks Patrick Mchardy for the hint. This
> patch requires the previous (7/8), otherwise it would break ctnetlink.

Both patches look good to me, although you probably should use
size_t or unsigned int for the cta_.*_min arrays, otherwise
I think gcc-4.x will complain.
