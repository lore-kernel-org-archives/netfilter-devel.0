Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A392184F;
	Wed, 17 Apr 2024 02:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713319818; cv=none; b=XSmFUJi38T9hFmRMZg6RD52h+ri8OUXXxUzzqhIMw36dbO7TFi9RJtDr3+UTnGnb93fo6+ghJvAcg8lLMzMUY620U/yt/phqAsyUIxhZ7EOfPAMcyIFmUcIY9aPQcmqSKYl7W8mYnL912dy9O1eeWoMLhwAgvaZk4YsoYIlwX6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713319818; c=relaxed/simple;
	bh=iQXAH9GDVARJSIBtw6I91vL4k2Xy/1mcs1G02+bi4wI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aUgHQS/EdXvjgr+Afgic5dPVNtsohVlP5PN4hVpb5mwU23gQiF5Vjuuy+SzoDx4kCkvEC83Slcg9rmpLksR1NS6/thuLXQYfXEuGmPrgXn8+VHvOIOze9N9EBNvxNVjGONOLY6AbGem0tCz5sBeCPNI7V8QKqhOwUbG4xlV/tD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SkV0IDPy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SkV0IDPy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 328B6C113CE;
	Wed, 17 Apr 2024 02:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713319817;
	bh=iQXAH9GDVARJSIBtw6I91vL4k2Xy/1mcs1G02+bi4wI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=SkV0IDPyE6shQFbvmfjG/binBVNqOf2YtsUGrFbegRjdm5UqDm4VXISeoh2kfMBp1
	 nFWSdbLU/PO8y7XUR9zk2BnZi87go/V4MjjzQWLRpQXKE4rs3xOdLmOZmqEfPBtupW
	 5vJql/hvCBCgx79vj5Er74DxiDM0nbJjiuL7E8LPVoiH5khj3aK1znpoNjvD8MXJNp
	 gU9tgtZbj3zFxHz+iscQn/bG0m9stamCfNAE8NGT1hZ8xHTlFeOBNEjV+6TDAj+dAN
	 nZ8UDEY3Z1jGO5RjjFYP0xAPxD2OOyKaO+rK3bAeswLiYTXgA8XIJlglqmd1h1FhQu
	 sa5ypnUsV8hqw==
Date: Tue, 16 Apr 2024 19:10:16 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Donald Hunter <donald.hunter@gmail.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Jiri Pirko
 <jiri@resnulli.us>, Jacob Keller <jacob.e.keller@intel.com>, Pablo Neira
 Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 donald.hunter@redhat.com
Subject: Re: [PATCH net-next v3 3/4] tools/net/ynl: Handle acks that use
 req_value
Message-ID: <20240416191016.5072e144@kernel.org>
In-Reply-To: <20240416193215.8259-4-donald.hunter@gmail.com>
References: <20240416193215.8259-1-donald.hunter@gmail.com>
	<20240416193215.8259-4-donald.hunter@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 16 Apr 2024 20:32:14 +0100 Donald Hunter wrote:
> The nfnetlink family uses the directional op model but errors get
> reported using the request value instead of the reply value.

What's an error in this case ? "Normal" errors come via NLMSG_ERROR

> diff --git a/tools/net/ynl/lib/nlspec.py b/tools/net/ynl/lib/nlspec.py
> index 6d08ab9e213f..04085bc6365e 100644
> --- a/tools/net/ynl/lib/nlspec.py
> +++ b/tools/net/ynl/lib/nlspec.py
> @@ -567,6 +567,18 @@ class SpecFamily(SpecElement):
>            return op
>        return None
>  
> +    def get_op_by_value(self, value):
> +        """
> +        For a given operation value, look up operation spec. Search
> +        by response value first then fall back to request value. This
> +        is required for handling failure cases.

Looks like we're only going to need it in NetlinkProtocol, so that's
fine. But let's somehow call out that this is a bit of a hack, so that
people don't feel like this is the more correct way of finding the op
than direct access to rsp_by_value[].
