Received: from smtp.forwardemail.net (smtp.forwardemail.net [149.28.215.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E851DA28
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Jan 2024 05:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=faucet.nz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fe-bounces.faucet.nz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=faucet.nz header.i=@faucet.nz header.b="bD8WH9+R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=faucet.nz;
 h=Content-Transfer-Encoding: MIME-Version: References: In-Reply-To:
 Message-Id: Date: Subject: Cc: To: From; q=dns/txt; s=fe-4ed8c67516;
 t=1704344723; bh=fgG3RR6ns0CBYeFcOflZPGhr9fVyxh18ERVWnEeDq2I=;
 b=bD8WH9+RlN16hufHYZMF/07I1gDRj1hle6W3s03f4PUUs5TBcdZMWg77G81nW8IXnYW8zJrfp
 qffgW/rBq5U7pmDVGhhjtmfDdMJzvwTSaJ+SfojoB3cKBohlCltfDhDbMKjCNEHCsricsYsCEA8
 uf/zDa6ghvZxxOjsMcdnUbo=
From: Brad Cowie <brad@faucet.nz>
To: aconole@redhat.com
Cc: brad@faucet.nz, coreteam@netfilter.org, davem@davemloft.net,
 dev@openvswitch.org, edumazet@google.com, fw@strlen.de, horms@kernel.org,
 kadlec@netfilter.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
 lucien.xin@gmail.com, netdev@vger.kernel.org,
 netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org
Subject: Re: [PATCH net] netfilter: nf_nat: fix action not being set for all ct states
Date: Thu,  4 Jan 2024 18:04:52 +1300
Message-Id: <20240104050452.808076-1-brad@faucet.nz>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <f7tle97eppk.fsf@redhat.com>
References: <f7tle97eppk.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Report-Abuse-To: abuse@forwardemail.net
X-Report-Abuse: abuse@forwardemail.net
X-Complaints-To: abuse@forwardemail.net
X-ForwardEmail-Version: 0.4.40
X-ForwardEmail-Sender: rfc822; brad@faucet.nz, smtp.forwardemail.net,
 149.28.215.223
X-ForwardEmail-ID: 65963c921192512af6adefb7

On Wed, 3 Jan 2024 at 04:10, Aaron Conole <aconole@redhat.com> wrote:

> LGTM.  I guess we should try to codify the specific flows that were used
> to flag this into the ovs selftest - we clearly have a missing case
> after NAT lookup.

Thanks for the review Aaron, and the sensible suggestion to add a
test to ovs to avoid this problem occuring again in future.

I've simplified our NAT ruleset and turned it into an ovs system test,
which I've submitted as a patch [1] to ovs-dev. The test reproduces
the issue introduced by ebddb1404900 and passes when e6345d2824a3
is applied.

[1]: https://mail.openvswitch.org/pipermail/ovs-dev/2024-January/410476.html
