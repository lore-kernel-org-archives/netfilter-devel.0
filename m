From: Massimiliano Hofer <max@nucleus.it>
Subject: Re: [PATCH] priv_data (formerly entry_data)
Date: Thu, 22 Jun 2006 01:50:20 +0200
Message-ID: <200606220150.23537.max@nucleus.it>
References: <200606050029.08602.max@nucleus.it>
	<200606210203.33209.max@nucleus.it> <44989321.2000106@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <44989321.2000106@trash.net>
Content-Disposition: inline
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

On Wednesday 21 June 2006 2:30 am, Patrick McHardy wrote:

> and finally rename ->checkentry to ->init .. the name doesn't really

What about struct xt_target?
It has the same general structure, but I've not touched it yet.
It would be coherent to change it too, but I'd break compatibility with 
external targets for no real gain.
Would any target benefit from having priv_data?

-- 
Saluti,
   Massimiliano Hofer
        Nucleus
