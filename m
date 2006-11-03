From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 06/11] Rename struct nf_conntrack_protocol
Date: Fri, 03 Nov 2006 13:07:46 +0100
Message-ID: <454B3112.1060200@trash.net>
References: <20061101210845.337590368@wlug.westbo.se>
	<20061101210913.910411244@wlug.westbo.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <20061101210913.910411244@wlug.westbo.se>
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

Martin Josefsson wrote:
> Rename 'struct nf_conntrack_protocol' to 'struct nf_conntrack_l4proto' in order
> to help distinguish it from 'struct nf_conntrack_l3proto'. It gets rather
> confusing with 'nf_conntrack_protocol'.

Applied, thanks.

Something related I wanted to do for a long time is get rid of the
confusing nf_ct_foo vs. nf_conntrack_foo naming.
