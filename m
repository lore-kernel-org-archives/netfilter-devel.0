From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: priority of MANGLE and NAT tables
Date: Wed, 10 Jul 2002 12:06:46 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200207101206.46182@henrik.marasystems.com>
References: <20020710080036.GA9220@napri.sk> <20020710091603.GO23676@naboo.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Peter Kundrat <kundrat@kundrat.sk>
In-Reply-To: <20020710091603.GO23676@naboo.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wednesday 10 July 2002 11.16, Harald Welte wrote:
> On Wed, Jul 10, 2002 at 10:00:36AM +0200, Peter Kundrat wrote:
> > before rewriting dst addr/port), and there is no mangle hook in
> > POSTROUTING (which would help, since it would be before SNAT).
>
> yes, there is. You must be using a relatively old kernel verison.
> Think this changed around 2.4.14

In patch-o-matic we also have the interesting match "conntrack" that 
solves many relevant issues..
