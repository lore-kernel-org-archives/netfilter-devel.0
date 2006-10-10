From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 00/05]: Small netfilter update
Date: Tue, 10 Oct 2006 06:38:45 +0200
Message-ID: <452B23D5.3020704@trash.net>
References: <20061002154716.13121.53265.sendpatchset@localhost.localdomain>
	<20061002.161344.92582699.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David Miller <davem@davemloft.net>
In-Reply-To: <20061002.161344.92582699.davem@davemloft.net>
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

David Miller wrote:
> Please submit the bug fixes as you see fit to -stable, in particular
> I'd like to see the Kconfig dependency fix go to 2.6.18-stable.  You
> can use this signoff line for any of those patches when submitting
> to -stable, thanks:
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>

Thanks, I'll push the first three patches today or tomorrow along
with a few backports from my last patchset.
