From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: tcp match silently drops packets
Date: Mon, 17 Oct 2005 15:35:41 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0510171531260.21372@filer.marasystems.com>
References: <4349D97A.9070708@snapgear.com>
	<200510160751.j9G7ph5t009316@toshiba.co.jp>
	<Pine.LNX.4.61.0510161931530.32106@filer.marasystems.com>
	<Pine.LNX.4.61.0510162247010.802@filer.marasystems.com>
	<4352EE9F.2020004@snapgear.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>
In-Reply-To: <4352EE9F.2020004@snapgear.com>
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

On Mon, 17 Oct 2005, Philip Craig wrote:

> What is the best way to log these then?

Good question.

> Perhaps modify the dropped table patch to catch hotdrops?

Hasn't the dropped table been abandoned entirely?

Today there is no logging of hotdropped packets from what I can tell. But 
adding a log function on hotdropped packets should not be very hard.. look 
for "if (hotdropped)" in ip_tables.c.

Regards
Henrik
