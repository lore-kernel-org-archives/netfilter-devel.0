Received: from Chamillionaire.breakpoint.cc (unknown [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700901D6DDD
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Mar 2025 14:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742569130; cv=none; b=d/H01SJTYsUp8ZZ1DXCunVr5NIi5zIz2boj6F8SNsQ6Yf+GhzH7AQKHjZCrpoDh5VVcjhLCy1NXRTlePUbe79V7QkiTkNNVVHmzzc3xkq0hcs1S8s31Nd/NpzIwOv32b7CBMF1/gn2IVdgjG5IjlLXRfnCMjmtFMBMfkFkThKcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742569130; c=relaxed/simple;
	bh=aY6AOrhom1jdKJhUMZquBnZd1Yr7TTQcugrT3Mfccwg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PLJx2qp/Fb97H84WWAz1OS5geOiiNkUVTdCQNcfbo9zpn2dxqhfpr1MHdxXDiDTevlq14t53v28qgQnJ0lh1FaBAi3PM6RBjvrvtkTSD423Ge3Bz4JDO+0KLMFwBFpkGOrYjV72NC2Cg4y3pLBqMbvkPxw8xp7kjtqtCam7ghak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tvdpd-0005Zg-Dr; Fri, 21 Mar 2025 15:58:45 +0100
Date: Fri, 21 Mar 2025 15:58:45 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nf-next] netfilter: replace select by depends on for
 IP{6}_NF_IPTABLES_LEGACY
Message-ID: <20250321145845.GC20305@breakpoint.cc>
References: <20250321103647.409501-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250321103647.409501-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Relax dependencies on iptables legacy, replace select by depends on,
> this should cause no harm to existing kernel configs and users can still
> toggle IP{6}_NF_IPTABLES_LEGACY in any case.

I applied following delta on top:

diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
--- a/net/bridge/netfilter/Kconfig
+++ b/net/bridge/netfilter/Kconfig
@@ -65,7 +65,7 @@ if BRIDGE_NF_EBTABLES
 #
 config BRIDGE_EBT_BROUTE
        tristate "ebt: broute table support"
-       select BRIDGE_NF_EBTABLES_LEGACY
+       depends on BRIDGE_NF_EBTABLES_LEGACY
        help
          The ebtables broute table is used to define rules that decide between
          bridging and routing frames, giving Linux the functionality of a
@@ -76,7 +76,7 @@ config BRIDGE_EBT_BROUTE
 
 config BRIDGE_EBT_T_FILTER
        tristate "ebt: filter table support"
-       select BRIDGE_NF_EBTABLES_LEGACY
+       depends on BRIDGE_NF_EBTABLES_LEGACY
        help
          The ebtables filter table is used to define frame filtering rules at
          local input, forwarding and local output. See the man page for
@@ -86,7 +86,7 @@ config BRIDGE_EBT_T_FILTER
 
 config BRIDGE_EBT_T_NAT
        tristate "ebt: nat table support"
-       select BRIDGE_NF_EBTABLES_LEGACY
+       depends on BRIDGE_NF_EBTABLES_LEGACY
        help
          The ebtables nat table is used to define rules that alter the MAC
          source address (MAC SNAT) or the MAC destination address (MAC DNAT).


./iptables-test.py -n
[..]
./extensions/libxt_TCPOPTSTRIP.t: ERROR: line 4 (cannot load: ip6tables -A PREROUTING -t mangle -p tcp -j TCPOPTSTRIP)
./extensions/libxt_TCPOPTSTRIP.t: ERROR: line 5 (cannot load: ip6tables -A PREROUTING -t mangle -p tcp -j TCPOPTSTRIP --strip-options 2,3,4,5,6,7)

The kernel module has a 'defined' check for ipv6 mangle table, not sure
yet how to replace this (ipv4 works).

shell tests worked.  I think we also might want to revisit/harmonize
arptables, ATM legacy support is controlled via IP_NF_ARPTABLES.

So perhaps (UNTESTED!) also change:
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -326,6 +326,7 @@ endif # IP_NF_IPTABLES
 config IP_NF_ARPTABLES
        tristate "Legacy ARPTABLES support"
        depends on NETFILTER_XTABLES
+       select NETFILTER_FAMILY_ARP
        default n
        help
          arptables is a legacy packet classifier.
@@ -340,9 +341,7 @@ config NFT_COMPAT_ARP
 
 config IP_NF_ARPFILTER
        tristate "arptables-legacy packet filtering support"
-       select IP_NF_ARPTABLES
-       select NETFILTER_FAMILY_ARP
-       depends on NETFILTER_XTABLES
+       depends on IP_NF_ARPTABLES
        help
          ARP packet filtering defines a table `filter', which has a series of
          rules for simple ARP packet filtering at local input and

