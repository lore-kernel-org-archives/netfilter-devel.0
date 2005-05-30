From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: list_for_each_entry usage and also ... (Re: [1/3] OSF: code
 beautification.)
Date: Mon, 30 May 2005 23:36:16 +0400
Message-ID: <20050530233616.6f901ffb@zanzibar.2ka.mipt.ru>
References: <20050530002000.4c63b34b@zanzibar.2ka.mipt.ru>
	<Pine.LNX.4.61.0505301528480.29095@e-smith.charlieb.ott.istop.com>
Reply-To: johnpol@2ka.mipt.ru
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Charlie Brady <charlieb-netfilter-devel@budge.apana.org.au>
In-Reply-To: <Pine.LNX.4.61.0505301528480.29095@e-smith.charlieb.ott.istop.com>
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

On Mon, 30 May 2005 15:30:20 -0400 (EDT)
Charlie Brady <charlieb-netfilter-devel@budge.apana.org.au> wrote:

> 
> On Mon, 30 May 2005, Evgeniy Polyakov wrote:
> 
> > { placement, copyright data change, list_for_each_entry usage.
> 
> Content changes should be kept separate from "code beautification" I 
> think.

Is it really necessary?
This is definitely a cleanup - nothing was changed in functionality, 
only couple of list_entry() removed...

	Evgeniy Polyakov

Only failure makes us experts. -- Theo de Raadt
