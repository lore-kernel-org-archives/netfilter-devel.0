From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: [LIBNFNETLINK] Introduce nfnl_listen_for_msecs
Date: Tue, 07 Feb 2006 15:33:51 +0100
Message-ID: <43E8AFCF.5040604@eurodev.net>
References: <43E7FC3A.4050209@eurodev.net> <43E8A810.6010108@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <43E8A810.6010108@trash.net>
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
>>The patch attached introduces a new function called
>>nfnl_listen_for_msecs. This is useful for polling netlink events.
> 
> Can you give an example how this is going to be used?

A program waits for some specific event, if it doesn't happen in a given
period of time, it gives up.

-- 
Pablo
