Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D8E4C8F;
	Wed,  5 Mar 2025 01:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741138359; cv=none; b=Z1x0t3P0h4Acuwtdy+lxOrByhdSUctNXZ5Q+eD32cek4ZZd6nfgKU7HUHj/IajHtmCaPc1RXoeflX0VGdmlRKxWnzRilNRppRkYxibou+HNIDObpaWSD+dr/a7j4nNiirf3X2VA4SnyJOje2NQKbrTh4MSGziGUHDMQ+2cW5snc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741138359; c=relaxed/simple;
	bh=90ftGxMtzgmgw63T+ebFUEeZzZeE6sckzEnTwq6VrAA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ro/0UKMZKdMcRHRlyES15SmqA065Ttf0iLVycqs7LAEqTcHHPmToJqy/bwOhRtvqthP1daLpfJzSfEoYOdc/0j7k96yoRsqNBrc9uxUAoqPWqW0N2LfdiT7RFxNH9UBE9Db/EjrLwQmhddtQXZ076yqkC1U5t/w6kwm2GzeN7Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XhD9TKt/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XhD9TKt/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56436C4CEE5;
	Wed,  5 Mar 2025 01:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741138358;
	bh=90ftGxMtzgmgw63T+ebFUEeZzZeE6sckzEnTwq6VrAA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=XhD9TKt/81RYE+xe2FPYplSy7LXsVIuPg4RZ3w8RUJQHtKY6mQOu5E1iEkZUPm+RS
	 rLRlFNrZoyUbrjYVcxNwxpceCtIZsl3ab7tvljb6lMF6ocQPjFsxjv0LUNtBxj5+22
	 JOvrEnQSbnXHgIJoDLSh7SaeiYwO9onFyv2e5ubxFi/mO1gqcVd9Xu58/72jaqpTcj
	 AE2Dyo5LF26/62YkuIfpRBJOZAkbWuxpfADb65ZFu++Bb8X9IFDVi7sRjFAcUc2QtD
	 Him5r/0PcBe1dAE8kP5DFHaz06pURGkfYF2vfOmKIILq6159nMnn6uhUe3FCExPj7R
	 72t4+n3PPbDSQ==
Date: Tue, 4 Mar 2025 17:32:36 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: chia-yu.chang@nokia-bell-labs.com
Cc: netdev@vger.kernel.org, dsahern@gmail.com, davem@davemloft.net,
 edumazet@google.com, dsahern@kernel.org, pabeni@redhat.com,
 joel.granados@kernel.org, andrew+netdev@lunn.ch, horms@kernel.org,
 pablo@netfilter.org, kadlec@netfilter.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, kory.maincent@bootlin.com, bpf@vger.kernel.org,
 kuniyu@amazon.com, andrew@lunn.ch, ij@kernel.org, ncardwell@google.com,
 koen.de_schepper@nokia-bell-labs.com, g.white@CableLabs.com,
 ingemar.s.johansson@ericsson.com, mirja.kuehlewind@ericsson.com,
 cheshire@apple.com, rs.ietf@gmx.at, Jason_Livingood@comcast.com,
 vidhi_goel@apple.com
Subject: Re: [PATCH v7 net-next 00/12] AccECN protocol preparation patch
 series
Message-ID: <20250304173236.717ad5b5@kernel.org>
In-Reply-To: <20250304151607.77950-1-chia-yu.chang@nokia-bell-labs.com>
References: <20250304151607.77950-1-chia-yu.chang@nokia-bell-labs.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  4 Mar 2025 16:15:58 +0100 chia-yu.chang@nokia-bell-labs.com
wrote:
> Subject: [PATCH v7 net-next 00/12] AccECN protocol preparation patch series

Please wait 24h in case someone has feedback, and then repost this
correctly.
