Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1406342CB6;
	Fri, 20 Feb 2026 12:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771591639; cv=none; b=r6b2VaPaSPwBYfpC6rwgdqsUTZkNEDLI6hXDoLrlGyKCT1jlvDTImIkQznAbNSTSTtQMuSe6FaZoCNDH6cWEumOHOxBlsoaNqOjLgQGpQlyD1pv7HbYHfk2ztasdIsk5fEng3mMjkO5WRiZLTm/1bRZxweOIfZldAWJ+9PFl4lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771591639; c=relaxed/simple;
	bh=JFyGMNfU/nR+ZUR/jVuKUGN28QnOydA4SyKTOSwSeO0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=U2G4wBXIat8re9pXV4dd7Ml5o17fAqZqoUNJevaEBInNZFFUxF7zyxOGLNTZsR6da4xI49fpXB5+gQX1CidS9XPM9Mi5aOJ0UxGkk/cM69oIEudsBj0VIrKtkGVFTPlecl9XLsagL8NoOren3WHCaC51S3qaECG4PRzKayIi4V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=tT4NR+V+; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="tT4NR+V+"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 3DF5F6017A;
	Fri, 20 Feb 2026 13:47:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1771591628;
	bh=ONyQV6T0+5t4Bd7vk7ir6GQcSh3D8DF7pd2iHbs5CtY=;
	h=Date:From:To:Cc:Subject:From;
	b=tT4NR+V+DMhgGSUIUcJ4Y5GFNxZRaZ3qpCAhKxzfXg9U5DBMCl99IGRuL1MJT1zbz
	 szN1CoA2puNxRi50wojvxPwfe7cp5Q96q+Ao8Re9fzfo4zF8sJvqwNErhhweSfwfyj
	 yGC8TRKfJuPBJQzPTBl88dwTFXeHUZTmxdfQC8y+npYLEB3XSY8I7CpjYLi78Prs6/
	 NkS+pKzPSYf5+5828ihrgId/IyaQB3f7TdquZ3ezhTaJnTjs9FtQ8Haz+rBBBp0E8n
	 5sxxdx9wPaFi8tQybb0VAz8MAMUmZ7srPg4+G+o62Ls4g/4sLqF8F9CJ8Th6UC8v0u
	 +5ennfG++muJw==
Date: Fri, 20 Feb 2026 13:47:05 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Cc: netfilter-announce@lists.netfilter.org, lwn@lwn.net,
	netdev@vger.kernel.org
Subject: [ANNOUNCE] iptables 1.8.12 release
Message-ID: <aZhXyS70BQ-JnSPg@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="a96Q5qd2CyaIn7KF"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit


--a96Q5qd2CyaIn7KF
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        iptables 1.8.12

This release contains the following fixes:

* Fix null dereference parsing bitwise operations.
* Refuse to run under file capabilities, ie. getauxval(AT_SECURE).
* Fix for all-zero mask on Big Endian in arptables-nft.
* Support adding and replacing a rule in the same batch in
  iptables-nft.

*filter
-A FORWARD -m comment --comment "new rule being replaced"
-R FORWARD 1 -m comment --comment "new replacing rule"
COMMIT

* Print -X in xtables-monitor command for base chains.
* Remove incorrect libebt_redirect translations.
* Translate bare '-m sctp' match to '-p sctp' just like TCP and UDP.
* Support for info-request and info-reply icmp types.
* Fix interface comparisons in `-C` commands in iptables-nft.
* Several fixes for ip[6]tables-translate, the tool to ease migration
  to nftables.
* Document flush behaviour with --noflush for user-defined chains.

See changelog for more details (attached to this email).

You can download this new release from:

  https://www.netfilter.org/projects/iptables/downloads.html
  https://www.netfilter.org/pub/iptables/

To build the code, libnftnl >= 1.2.6 is required:

  http://netfilter.org/projects/libnftnl/downloads.html

In case of bugs and feature requests, file them via:

  https://bugzilla.netfilter.org

Happy firewalling.

P.S: tarball and website update is available since yesterday, I could
not deliver this cover letter until today, apologies for this delay.

--a96Q5qd2CyaIn7KF
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="changes-iptables-1.8.12.txt"
Content-Transfer-Encoding: 8bit

Achill Gilgenast (1):
      configure: Avoid addition assignment operators

Alan Ross (1):
      libxtables: refuse to run under file capabilities

Florian Westphal (2):
      man: iptables-restore.8: document flush behaviour for user-defined chains
      nft: revert compat expressions in userdata

Jeremy Sowden (2):
      ip[6]tables-translate: fix test failures when WESP is defined
      nft: fix interface comparisons in `-C` commands

Miao Wang (1):
      extensions: libebt_redirect: prevent translation

Pablo Neira Ayuso (1):
      configure: Bump version for 1.8.12 release

Phil Sutter (20):
      nft: Drop interface mask leftovers from post_parse callbacks
      nft: Make add_log() static
      nft: ruleparse: Introduce nft_parse_rule_expr()
      nft: __add_{match,target}() can't fail
      nft: Introduce UDATA_TYPE_COMPAT_EXT
      nft-ruleparse: Fallback to compat expressions in userdata
      nft: Pass nft_handle into add_{action,match}()
      nft: Embed compat extensions in rule userdata
      tests: iptables-test: Add nft-compat variant
      extensions: icmp: Support info-request/-reply type names
      xshared: Accept an option if any given command allows it
      extensions: sctp: Translate bare '-m sctp' match
      libxtables: Promote xtopt_esize_by_type() as xtopt_psize getter
      Revert "libxtables: Promote xtopt_esize_by_type() as xtopt_psize getter"
      xtables-monitor: Print -X command for base chains, too
      nft: Support replacing a rule added in the same batch
      libxtables: Store all requested target types
      ruleparse: arp: Fix for all-zero mask on Big Endian
      tests: shell: Review nft-only/0009-needless-bitwise_0
      configure: Auto-detect libz unless explicitly requested

Remy D. Farley (1):
      iptables: fix null dereference parsing bitwise operations

Łukasz Stelmach (1):
      extensions: man: Add a note about route_localnet sysctl


--a96Q5qd2CyaIn7KF--
