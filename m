From: Patrick McHardy <kaber@trash.net>
Subject: Re: [H.323 Helper 2/5]: Change helper definitions
Date: Sat, 17 Jun 2006 17:21:19 +0200
Message-ID: <44941DEF.3010106@trash.net>
References: <BAY109-DAV452CF9E30E212AFCB471CB3880@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jing Min Zhao <zhaojingmin@hotmail.com>
In-Reply-To: <BAY109-DAV452CF9E30E212AFCB471CB3880@phx.gbl>
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

Jing Min Zhao wrote:
> Change helpers' structure definitions to meet some old compilers.
> 
> Signed-off-by: Jing Min Zhao <zhaojingmin@users.sourceforge.org>

This seems to be for gcc-2.95, which isn't supported by the
kernel anymore.
