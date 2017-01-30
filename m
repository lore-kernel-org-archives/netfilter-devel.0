From: David Miller <davem@davemloft.net>
Subject: new patch state in patchwork...
Date: Mon, 30 Jan 2017 15:38:19 -0500 (EST)
Message-ID: <20170130.153819.2199482108994890531.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-wireless@vger.kernel.org, netfilter-devel@vger.kernel.org
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


I noticed there is a new state "Needs Review / ACK" in patchwork.

I am going to use this for situations where I am explicitly waiting
either for a maintainer, or someone referenced directly in the patch
discussion, to review and ACK/NACK the change.

Just FYI...
