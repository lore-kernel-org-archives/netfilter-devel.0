From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [HEADS UP] Migrating ebtables and arptables to netfilter.org
Date: Tue, 27 May 2014 10:33:59 +0200
Message-ID: <20140527083359.GA4342@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter@vger.kernel.org, bridge@lists.linux-foundation.org,
	Bart De Schuymer <bdschuym@pandora.be>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi!

We're migrating arptables and ebtables to git.netfilter.org. The new
location for the repositories are:

1) arptables:

        git://git.netfilter.org/arptables
        http://git.netfilter.org/arptables/

2) ebtables:

        git://git.netfilter.org/ebtables
        http://git.netfilter.org/ebtables/

Originally, these two applications were located in the same repository
which has been kept at:

        http://git.netfilter.org/ebtables.old-history/

just for the record.

I have git-filter-branch the original repository to separate the
ebtables and the arptables in two independent repositories.

Let me know if you experience any problem in this migration,
Thanks.
