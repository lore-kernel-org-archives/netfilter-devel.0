From: "David S. Miller" <davem@redhat.com>
Subject: Re: [TRIVIAL] place IPv4 netfilter submenu where it belongs
Date: Sun, 27 Jul 2003 16:09:42 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030727160942.647707d8.davem@redhat.com>
References: <20030726200646.GF16160@louise.pinerecords.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Tomas Szepe <szepe@pinerecords.com>
In-Reply-To: <20030726200646.GF16160@louise.pinerecords.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 26 Jul 2003 22:06:46 +0200
Tomas Szepe <szepe@pinerecords.com> wrote:

> $subj
> 
> Patch against -bk3.

This doesn't look right at all.

Netfilter is for many protocols other than ipv4 (ipv6, bridging,
decnet, etc.) so putting it under ipv4 makes not much sense
to me.

If anything, probably the "depends on INET" could need correction.
