Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="nXX+d9Xl"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DFE9D53
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Nov 2023 03:04:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=K3TcdqOvvyJ0nOupYqNN+hj31Xea6VK9R3u/4CyATs8=; b=nXX+d9Xl2xYDVznvIdHtz02fvA
	1X+0XYnLcIXKoDhtuSilq4p4lHic/ravP1eYiJxszeW/iWmOIz1TAn9BDnyCifLigLqXt6uIdlhIH
	dQuKUL15/gN3iEXTU7dPSNIpsIVdwyrb91ipI3MOFz9tM4shEC/6aRIKRzGe6hOkuaQ1fe+vp3OAJ
	hUV9i6ra6gaWxGbr7Vnke4ypcfvgGnv8HSIQCvQ+bMkKc8InRQ0msV3JnwoVGfy//VxAg89bQ1o2l
	uuKz1XHRQIt9WBRDW+bVGblT4c9TnJbFZrwf1Iu8eDLAkr/gQJmAk1nIjouO6B9WInd0LPZiHslbT
	TNCFuG7A==;
Received: from localhost ([::1] helo=minime)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1r6Typ-0002Iu-GP
	for netfilter-devel@vger.kernel.org; Fri, 24 Nov 2023 12:04:15 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 0/3] xshared: Review option parsing
Date: Fri, 24 Nov 2023 12:13:22 +0100
Message-ID: <20231124111325.5221-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Faced with the need to extend optflags, inverse_for_options and
commands_v_options arrays in order to integrate ebtables-specific
options, I chose to get rid of them all instead.

Patch 1 replaces opt2char() function which didn't work well since not
every option has printable short-option character. The callback-based
replacement returns the long-option and should make error messages more
readable this way.

Patch 2 elminates the inverse_for_options array along with the loop
turning a given option into its bit's position for use in the array. The
switch statement in the replacing callback is much easier to maintain
and extend.

Patch 3 makes use of the fact that no command has a mandatory option
anymore. So every combination is either allowed or not, and a single bit
may indicate that.

Phil Sutter (3):
  xshared: Introduce xt_cmd_parse_ops::option_name
  xshared: Introduce xt_cmd_parse_ops::option_invert
  xshared: Simplify generic_opt_check()

 iptables/ip6tables.c |   2 +
 iptables/iptables.c  |   2 +
 iptables/nft-arp.c   |  32 ++++++
 iptables/nft-ipv4.c  |   2 +
 iptables/nft-ipv6.c  |   2 +
 iptables/xshared.c   | 249 ++++++++++++++++++++-----------------------
 iptables/xshared.h   |   6 ++
 7 files changed, 159 insertions(+), 136 deletions(-)

-- 
2.41.0

