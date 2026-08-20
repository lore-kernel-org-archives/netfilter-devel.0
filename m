Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED14C3BB11F
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2026 11:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787226529; cv=none; b=EiBXGxHVW7dUdxOQg8UEfujDBD1UP0YoGg0iCdrFYAo5jcvHR2JtDXGP667cUSH055fLTCgtov/VCWOdXfUaH2wLeGsTKxQuGJnfDU85kPGgQL93B8QfBNYjYekbzaa/4qhhWib1eaF8IhaBrv3otmxWNMqyc2GMTtqojxUYH+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787226529; c=relaxed/simple;
	bh=nUYbQfHTXNlICrN9S87vLenzGB3kyr3UnrqpmAMUtfQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jg2E87qTkyKIMrMD9PQX/ePQNesNrXz6iIB4bVVAqAQhK5FzkRA9mtF3XnfRTcWKB/luvL90qQ4McnZCQrj/SKPkNBjrAGP4sIiMhSABT6stHLF+MBHtmHQcyem0CDysbdTr4o3/EsXyUq1oSfwnExVEXDdyoi3L32WS+/vGfkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Wp7CFMbF; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Wp7CFMbF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787226524;
	bh=doPzA1asz1KhPpoTjeYPt3sfnBWSoVa3IsZAtM/RoOI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Wp7CFMbFXgZqymKnyE4oV6Ee/I50p2KjoOy6VoypKTETibGNgjVl1w0gzm0qEaMTB
	 Kyw4IlC4zrqx8IID6yXJVs+Nyv5jFZjn+lwutpYqiWQ1VR8zy7YIveSNhwY5MvxICB
	 c29418jVJ+8ngdBbMAje38Sy51hFZkEKJHuuwPr6BzaWyIoJeP+h/c79knYp3Rokmg
	 g+xdp4Fdw8kYWj0fOO3gPezJuoOwTfmm40cwddyE6zVAvx70p+XN3Yo5bAz88P1ZxC
	 WfBdMROB2J1HRk/r3DiKDAIexzsv6Qt94HHea2NU6vS1uRaAIxkIq7h9pTNNlQ+5QP
	 V5O+j+qo0T8cA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 338C160090;
	Thu, 20 Aug 2026 13:48:44 +0200 (CEST)
Date: Thu, 20 Aug 2026 13:48:42 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Gergely Palotas <palotasgergely@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 1/2] parser_json: fix CMD_OBJ/NFT_OBJECT mismatch in
 delete path
Message-ID: <aobpmrzacegPC4AU@chamomile>
References: <20260811134326.300827-1-palotasgergely@gmail.com>
 <20260811134326.300827-2-palotasgergely@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260811134326.300827-2-palotasgergely@gmail.com>

On Tue, Aug 11, 2026 at 03:43:25PM +0200, Gergely Palotas wrote:
> The dispatch tables in json_parse_cmd_add() and json_parse_cmd_list()
> pass NFT_OBJECT_CT_TIMEOUT, NFT_OBJECT_CT_EXPECT and NFT_OBJECT_TUNNEL
> (kernel constants from <linux/netfilter/nf_tables.h>) as the cmd_obj
> argument to json_parse_cmd_add_object(), which declares its parameter
> as enum cmd_obj.
> 
> On the delete/list/destroy early-return path, cmd_obj is forwarded
> directly to cmd_alloc(), which expects enum cmd_obj values. For ct
> timeout, NFT_OBJECT_CT_TIMEOUT=7 aliases to CMD_OBJ_CHAIN=7, so a
> JSON delete of a ct timeout is sent to the kernel as a delete chain
> netlink message, returning EINVAL. The same mismatch affects ct
> expectation and tunnel objects.
> 
> The add path was unaffected because the switch/case blocks inside the
> function also used NFT_OBJECT_* constants and contained explicit
> cmd_obj = CMD_OBJ_* assignments before falling through to cmd_alloc().
> Those assignments are never reached on the delete path due to the
> early return.
> 
> Fix this by using CMD_OBJ_* constants consistently in the dispatch
> tables, matching the declared type of the parameter. Update the
> switch cases and the CT_HELPER identity checks in the function
> prologue to use CMD_OBJ_* as well, and drop the now-unnecessary
> cmd_obj reassignments inside each case.

cmd_alloc_obj_ct() expects NFT_OBJECT_CT_*

        switch (type) {
        case NFT_OBJECT_CT_HELPER:
                cmd_obj = CMD_OBJ_CT_HELPER;
                break;
        case NFT_OBJECT_CT_TIMEOUT:
                cmd_obj = CMD_OBJ_CT_TIMEOUT;
                break;
        case NFT_OBJECT_CT_EXPECT:
                cmd_obj = CMD_OBJ_CT_EXPECT;
                break;
        default:
                BUG("missing type mapping");
        }

Maybe this needs to be updated so this looks consistent?
