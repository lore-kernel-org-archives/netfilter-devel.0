From: "David S. Miller" <davem@redhat.com>
Subject: Re: Extremely slow network with e1000 & ip_conntrack
Date: Thu, 4 Dec 2003 10:30:41 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031204103041.21aefd8d.davem@redhat.com>
References: <C6F5CF431189FA4CBAEC9E7DD5441E0102CBDD21@orsmsx402.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: mukansai@emailplus.org, laforge@netfilter.org,
        netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Feldman, Scott" <scott.feldman@intel.com>
In-Reply-To: <C6F5CF431189FA4CBAEC9E7DD5441E0102CBDD21@orsmsx402.jf.intel.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 4 Dec 2003 09:37:19 -0800
"Feldman, Scott" <scott.feldman@intel.com> wrote:

> TSO is support on 82540.  Turning off TSO is a workaround, but what's
> behind the dependency of TSO and ip_conntrack?

Netfilter wants to see the _real_ packets that will be sent onto the
wire.  TSO is a template by which to create such packets, not the real
thing.

So when and if we go into netfilter, we must un-TSO the packet so
that netfilter can look at what it really wants to.
