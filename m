From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] [NETFILTER] Fix CID offset bug in PPTP NAT helper
Date: Tue, 24 Jan 2006 18:59:44 +0100
Message-ID: <43D66B10.6040803@trash.net>
References: <11381105772146-git-send-email-heitzenberger@astaro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Holger Eitzenberger <heitzenberger@astaro.com>
In-Reply-To: <11381105772146-git-send-email-heitzenberger@astaro.com>
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

Holger Eitzenberger wrote:
> The recent (kernel 2.6.15.1) fix for PPTP NAT helper introduced a
> bug - which only appears if DEBUGP is enabled though.
> 
> The calculation of the CID offset into a PPTP request struct is
> not correct, so that at least not the correct CID is displayed
> if DEBUGP is enabled.
> 
> This patch corrects CID offset calculation and introduces a #define
> for that.

That was my bad. Patch applied, thanks.
