From: Henrik Nordstrom <hno@marasystems.com>
Subject: RE: CONNMARK again..
Date: Tue, 23 Mar 2004 09:19:57 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403230902240.30008-100000@filer.marasystems.com>
References: <7C9884991ADAE0479C14F10C858BCDF5679238@alderaan.smgtec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Daniel Chemko <dchemko@smgtec.com>
In-Reply-To: <7C9884991ADAE0479C14F10C858BCDF5679238@alderaan.smgtec.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 22 Mar 2004, Daniel Chemko wrote:

> This is a freshly compiled 1.2.9 against the current kernel. Unless the
> API for CONNMARK has changed in the backend since 1.2.9 I don't see how.

CONNMARK was changed after 1.2.9.

> The userspace did compile against the updated POM kernel, so I'm not
> sure else where it fails. New iptables binaries dfrom CVS reports
> "Invalid argument" or the such when doing NAT work, so I am stuck to
> 1.2.9...

Works here... 

2.4.26-pre5 + patch-o-matic pending + patch-o-mathc-ng lots of interesting
stuff

Regards
Henrik
