From: Henrik Nordstrom <hno@marasystems.com>
Subject: RE: CONNMARK again..
Date: Tue, 23 Mar 2004 18:27:43 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403231823490.3009-100000@filer.marasystems.com>
References: <7C9884991ADAE0479C14F10C858BCDF567923B@alderaan.smgtec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Daniel Chemko <dchemko@smgtec.com>
In-Reply-To: <7C9884991ADAE0479C14F10C858BCDF567923B@alderaan.smgtec.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 23 Mar 2004, Daniel Chemko wrote:

> Does the iptables module in CVS build against POM or POM-ng these days?

CONNMARK is the same in both POM and POM-NG, but in future only POM-ng is 
updated.

> Also, does POM-ng include the 2.4 patches, or is it strictly for 2.6
> kernels?

POM-ng is mainly for 2.4 kernels, but 2.6 support is being added (2.6
support could not be added in POM). iptables extensions is also being 
moved to POM-ng to reduce the version dependency of iptables.

Regards
Henrik
