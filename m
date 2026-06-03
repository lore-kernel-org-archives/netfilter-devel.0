Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A233822AA
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Jun 2026 19:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780514972; cv=none; b=Fz4KQ/GUPryDDagr4VR/QRRzuLuNs994sfz2QbfJOxfc4N07xU1O6UqgP3xAYNQ9WncS3Y8xTuCG3XT6YITScSzU1hVtuX+3yyUAiwCIekROMN/WcD/ZkdtqXBl9iZzXea6469mWbtBGckcl5ZbaVeP//TWTzOGqE1wg4gkoDy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780514972; c=relaxed/simple;
	bh=Jd385MQ0Pk9zlR/sWsSi7wiDBHZQ7yrc3MT1qWzj1ng=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Caa3QPz2Z4HXqf66ZrcLCq7ANwCT7VM5KFZ5oxfvagQOOqshjMWTZb4YBSHg+ISXv7FMofz3RKq731+0cDUqI95KAn5S9uAB8BUPF466Wt38/alOObobcLoNBB1okkGCe47bO+UtfmQUoH/rVxX8CNklOyyH0NIvJLao47JGOEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=eoEy7Nk1; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="eoEy7Nk1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=VvtSEhA6h3MEwYL+KH8bBVj9Q/CvLg0cqDsWsIwIyRo=; b=eoEy7Nk12bHxwFh6L/mx4AcGTo
	bwiLtazh5YHWRlURXCR9Jb7UbwjNXnoqP3g/lYv3QWb/u8vgD3RnapV9eOdf6As2M3TwYkARpF1aj
	dJWyBLoAzhHF3LFqbddqWWrrmAN3CHuMbzQFEU/XGiXOYNHy619WxukyIJbZViu0JuUrBrmItyqst
	EHdkiVneYH6hh0ydkIiQcvz+cXCR9G6ikXmbsiuB7e02nTATuwgO8q58jntPO1zRWqA3j264Ff6XG
	dkIjTSpqKW88l13HpQL00GWmuuQnO9og+8TIGEP9PKTtkAuwrNVuFCimf5w2yKz3oxQUTipO4sLbr
	VfJTqyXA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wUrHM-0000000033a-1dH3;
	Wed, 03 Jun 2026 21:29:28 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 0/6] Eliminate variable declarations in switch cases
Date: Wed,  3 Jun 2026 21:29:17 +0200
Message-ID: <20260603192923.1378815-1-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Older versions of gcc complain about it and there's no real need for it.

Since affected functions were pretty big due to the rather complex
tunnel object, move the tunnel-specific code into own functions in
patches 1, 2 and 4.

Patch 3 reduces duplicate code in obj_print_data() before patch 4 then
pulls out the tunnel-specific part, so this is a kind of soft dependency
there.

Remaining cases of variable declaration in switch cases are taken care
of by patch 5.

Finally, there is patch 6 which reduces code size by calling
nftnl_tunnel object getters unconditionally, leveraging the fact that
these return zero for unset attributes and thus don't change the
(zeroed) object in that case.

Phil Sutter (6):
  json: Introduce tunnel_obj_print_json()
  parser_json: Introduce json_parse_tunnel()
  rule: Turn obj_print_comment() into obj_print_header()
  rule: Introduce tunnel_obj_print_data()
  src: Avoid variable declarations in switch cases
  netlink: Call tunnel getters unconditionally

 src/json.c        | 115 +++++++++++---------
 src/mnl.c         |   3 +-
 src/netlink.c     | 117 ++++++++------------
 src/parser_json.c | 144 ++++++++++++------------
 src/rule.c        | 272 +++++++++++++++++++++-------------------------
 5 files changed, 307 insertions(+), 344 deletions(-)

-- 
2.54.0

