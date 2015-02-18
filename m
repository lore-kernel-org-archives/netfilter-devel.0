From: Oleg <lego12239@yandex.ru>
Subject: nft & notrack
Date: Wed, 18 Feb 2015 19:52:16 +0300
Message-ID: <20150218165216.GA7432@localhost>
Reply-To: Oleg <lego12239@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

  Hi, all.

Is anybody known how to replace the next iptables rule with nft:

iptables -t raw -A PREROUTING -i eth0 -j CT --notrack

Is this possible with nft or not?

Thanks.

-- 
Nemanov Oleg
