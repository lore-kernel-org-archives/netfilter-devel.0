From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: read conntrack table
Date: Wed, 30 Jun 2004 13:04:17 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0406301303370.6445-100000@filer.marasystems.com>
References: <40E29A2A.9000707@cisbic.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@lists.netfilter.org,
   netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Fallucchi Antonio <fallucch@cisbic.com>
In-Reply-To: <40E29A2A.9000707@cisbic.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 30 Jun 2004, Fallucchi Antonio wrote:

> there is a function/code for read/parse the ip_conntrack table?

In user or kernelland?

For a reasonable userland api see ctnetlink (pom-ng).

Regards
Henrik
