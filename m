From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] tcp-window-tracking patch
Date: Tue, 9 Dec 2003 14:08:59 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0312091404540.25001-100000@filer.marasystems.com>
References: <Pine.LNX.4.33.0312091121400.5228-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0312091121400.5228-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 9 Dec 2003, Jozsef Kadlecsik wrote:

> - close_wait timeout value is lowered to the more proper 10 minutes

Is this a "silence" timeout extended if there is traffic, or a session
timeout after enterig close_wait no matter if there is traffic or not?

If the first then 10 minutes should be sufficient for most uses, even if 
there quite likely is some applications which will fail this..

If the latter then 10 minutes is certainly not sufficient.

Regards
Henrik
