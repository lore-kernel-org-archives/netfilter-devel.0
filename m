Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.182.14
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794273785;
	b=a4bmwBkdws8qg4lJtIDV06BYhgzSwS9d5YlzbcuF7cSBxQ34QDHyqdLPlJCepFERNluN
	 PIkObERVnOdP9gGvZGL7eYe2qXiXF4X20pQuwYqcTV3ojlxKj/Ytuy+8AazSQl9DBxL60
	 dPHLnEz1SDQu+bUzSwtLbOU+827kDeJUKsxGudJMua8YLFmKKnHzMNOuWP2IOvfthFphx
	 CWNRuLqULAt64sxghWBC0iSVbuebL4hWXPb58AVnPU3UVdpAUPHC1wvPCS35pflAuWV6m
	 puo40jGXdPF6fCESnLg/dlVR2qvow7DMi/glw+txL6J+uQUv99j6TnRYVmGlRIdUiNg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794273785;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-ZohoMailClient;
	bh=rlHy0y49llRfh6fikqJG2D8BwX2hQJXYBow41oy5Q2M=;
	b=abHYi9cus0gGoPR2CTISOvd7Ff+SvANBPIU3Idd0nf6Quq0+g6irelQVmpezZgxcmo01
	 dySoH3Yqlqrw0YvBvxZL+072ZNZFjtXieJYmutJuW+pJJvmTLXTI1AVVyW8FLqRGNbiRF
	 gmN2wkgzpGhwgmgAQzCPgcma5leJ3qIi758eLuHdpGKumLk7B4p6ZzZ+YL0HD8jkV/PRU
	 pqyTsl8UqECN7WFzakN19EcoKxIr16I6gCaF6UyE6UL6vft/gGwOlOCxR3STaTjflwBJE
	 0Tn58FpH6wmCyPSbMtjjU3029wquEp/4BF7plbBxR99YWxZMzgTifyVzZpraJj/x79A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=laveeshbansal.com;
	spf=pass smtp.mailfrom=laveeshbansal.com;
	dkim=pass header.d=laveeshbansal.com header.i=@laveeshbansal.com header.a=rsa-sha256 header.s=zoho header.b=Ixuoifn6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.182.14
Received: from sender5-op-o14.zoho.com (sender5-op-o14.zoho.com [165.173.182.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB586071843;
	Tue, 10 Nov 2026 01:23:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8AB586071843
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=laveeshbansal.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=laveeshbansal.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=laveeshbansal.com header.i=@laveeshbansal.com header.a=rsa-sha256 header.s=zoho header.b=Ixuoifn6
ARC-Seal: i=1; a=rsa-sha256; t=1794273772; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=iDGzEyufbjEQX95PG5nPvHvs5AMuZmtGu4mw0NdgDlk73mtUNJJs4DPlPf68OY3XdeWa0qRpXgjVbHL4zg93Tw0nmCaFg6+dj7b9pCzMd7lukcQIgHnrk2AJ3U6yPIv7MNC/Cn8k2K8gHzdQSHkw6sXnzYRxC7sMvxrUTZN7pds=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1794273772; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=rlHy0y49llRfh6fikqJG2D8BwX2hQJXYBow41oy5Q2M=; 
	b=kYEso761Ka2+hBJ4bPYq+9XhWLsYgyQm51BIJLLeJol7wnqLzfe270i4Z4UOyilHOuttVrs9tBbMMkB5gwSnTniL1lzdHo2PxtFxGAipnd1+M5rKiDj1WFlXLlsvZDTe8v2CmHAvv++CV9zDMYZZKBycaR+FTJm2FdSgaE83K6E=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=laveeshbansal.com;
	spf=pass  smtp.mailfrom=laveeshb@laveeshbansal.com;
	dmarc=pass header.from=<laveeshb@laveeshbansal.com>
DKIM-Signature: a=rsa-sha256; b=Ixuoifn6KXRdy+uBBsMQal6LYGKErlO6lUAzmKWQdYzDzYEtpzdithJnHXn6+6/3fqlMU6F73bvJ4NLsa9QUdAJDaryvd0zHPCZIauUU7lRH2xuEbk8N/Yv1drV/X0noUpGjBB0z24bFZyssv3/GMBFFfS7vP/ghHNIUFlCvcks=; c=relaxed/relaxed; s=zoho; d=laveeshbansal.com; v=1; bh=rlHy0y49llRfh6fikqJG2D8BwX2hQJXYBow41oy5Q2M=; h=Content-Description:Content-ID:Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:List-Subscribe:List-Post:List-Owner:List-Id:List-Archive:List-Help:List-Unsubscribe:MIME-Version:Message-ID:Resent-Sender:Resent-Cc:Resent-Date:Resent-To:Reply-To:Resent-Message-ID:Resent-From:Sender:Subject:To:Date:From:Message-Id:Reply-To:Subject:To:Cc;
Received: by smtp.zohomail.com with SMTPS id 1794273770551191.82694000317304;
	Mon, 9 Nov 2026 17:22:50 -0800 (PST)
From: Laveesh Bansal <laveeshb@laveeshbansal.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	syzbot+a8ba738fe2db6b4bb27f@syzkaller.appspotmail.com,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	netdev@vger.kernel.org
Subject: Re: [PATCH nf-next 0/2] netfilter: bridge: refragment packets with a vlan tag moved by the bridge
Date: Mon,  9 Nov 2026 17:22:44 -0800
Message-ID: <20261110012244.69518-1-laveeshb@laveeshbansal.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <avJuijtALFuuk7yd@chamomile>
References: <avJuijtALFuuk7yd@chamomile>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

On Tue, Nov 10, 2026 at 02:08:26AM +0100, Pablo Neira Ayuso wrote:
> But does it make sense what syzbot is trying in real life?

Here is a sample scenario: a customer sends large fragmented UDP packets
into a bridge doing QinQ with stateful bridge rules. It takes that
combination so it is rare.
