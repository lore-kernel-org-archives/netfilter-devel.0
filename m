From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] exthdr: Add support for reserved header and address
Date: Mon, 2 Oct 2017 21:08:44 +0200
Message-ID: <20171002190844.GA1164@salvia>
References: <1506890220-12226-1-git-send-email-harshasharmaiitr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        outreachy-kernel@googlegroups.com
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1506890220-12226-1-git-send-email-harshasharmaiitr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Harsha,

On Mon, Oct 02, 2017 at 02:07:00AM +0530, Harsha Sharma wrote:
> Add support for IPV6 type 0 routing header reserved field and address
> unable to test it with nft-test.py

It seems you didn't test this patch.

# python nft-test.py ip6/rt.t

/home/pablo/devel/scm/git-netfilter/nftables/tests/py/ip6/rt.t.payload.ip6:
ERROR: line 2: did not find payload information for rule 'rt type 0 reserved 2'
ip6/rt.t: ERROR: line 48: src/nft add rule --debug=netlink ip6 test-ip6 input rt type 0 reserved 2: This rule should not have failed.
ip6/rt.t: 39 unit tests, 1 error, 0 warning

There's a README file under tests/py folder that explains how the test
infrastructure works.

Anyway, you also have to perform basic testing by hand on your
patches.

Thanks!
