From: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 0/9] genetlink: reduce ops size and complexity (v2)
Date: Thu, 14 Nov 2013 17:14:38 +0100
Message-ID: <1384445687-30948-1-git-send-email-johannes@sipsolutions.net>
References: <1384420486-8713-1-git-send-email-johannes@sipsolutions.net>
Cc: linux-wimax@intel.com, Balbir Singh <bsingharora@gmail.com>,
	netfilter-devel@vger.kernel.org,
	Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
	Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1384420486-8713-1-git-send-email-johannes@sipsolutions.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

As before - reduce the complexity and data/code size of genetlink ops
by making them an array rather than a linked list. Most users already
use an array thanks to genl_register_family_with_ops(), so convert the
remaining ones allowing us to get rid of the list head in each op.

Also make them const, this just makes sense at that point and the security
people like making function pointers const as well :-)

johannes
