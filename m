From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: 2.4 SNAT fails randomly
Date: Tue, 18 Nov 2003 17:20:45 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031118162045.GF4086@balabit.hu>
References: <200311151103.47454.timg@tpi.com> <20031116095206.GA32471@balabit.hu> <200311160953.51722.timg@tpi.com> <200311180835.09794.timg@tpi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Tim Gardner <timg@tpi.com>
Content-Disposition: inline
In-Reply-To: <200311180835.09794.timg@tpi.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, Nov 18, 2003 at 08:35:09AM -0700, Tim Gardner wrote:
> I've been thinking more about this scenario. When a standard distribution like 
> SuSE-9.0 boots, the interfaces are  IFF_UP sometime before firewall rules are 
> installed. This is particularly a problem in the case of a NAT router. Is 
> there any way to flush /proc/net/ip_conntrack to make sure that you get rid 
> of entries that were established between the time the interfaces were brought 
> up and the time the rules were installed? Removing the ip_conntrack modules 
> seems kind of brute force, and does not work on kernels where ip_conntrack is 
> not a module.

I think this scenario is inherently broken and the distribution should be
fixed. It is meant to be possible to load rulesets when the interfaces are
not yet configured.

Nevertheless the possibility to clear the conntrack table is desperately
needed as well as other conntrack manipulations. This area is getting less
neglected with the introduction of ctnetlink, albeit process is slow.

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
