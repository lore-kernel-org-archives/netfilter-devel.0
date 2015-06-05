From: Patrick McHardy <kaber@trash.net>
Subject: nft netdev family bindings
Date: Fri, 5 Jun 2015 15:35:33 +0200
Message-ID: <20150605133533.GA4024@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59862 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbbFENfh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2015 09:35:37 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

looking at the netdev syntax:

table netdev eth0 {
	device eth0;
	...

I think this "device" specification is inconsistent with out normal use
of handles. Usually the table_spec contains the fully qualified handle,
which in this case needs to include the device.

Consider:

table netdev somename {
	device eth0;
	...

table netdev somename {
	device eth1;
	...

Without including the device in the table handle, the name alone is amiguitios.
I'd propose to use

table netdev <dev> <name>

Just as we have the family in the handle.
