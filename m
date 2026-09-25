Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDDB440632;
	Fri, 25 Sep 2026 14:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790346240; cv=none; b=fExl4YP4QN6wbNe9oaS/tuHSshjCBiN9FjfWCkYwDbusA46JnUHIr5vEojIuo/tAnWwSdkpRntSWCcEm92Up4lr3feJ3/oScUfbUAwbf/k3KhVmaJw0XBXDjAWA3J4ROdfuf/eiObXFKvsjXutPRDbVG9ovfE8goJf4/OIP+BoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790346240; c=relaxed/simple;
	bh=MumCk2iQV8NfZ4FIye7VSM07PHu0TroAPaJIbu0QsCo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YYL3iHWW9XCu0cRy/03O00NZ4+idAYDqF3Jo5vTb2GVfWEAbbC/FMbTq4NVD3pG5bdrf1sjDl1A4otopfzNguvsbJzdrPmQIp0nOXAEPK+uUxY7c3i4eMbIF64Dqhtn5i/rBQsBcdMDWF1CzBXdvgmrVtAaJDxumLhPf5pMw7OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uv++AnLt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uv++AnLt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29BEC1F000FF;
	Fri, 25 Sep 2026 14:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790346238;
	bh=gPQw0BITWNXX7SKrbkyHcPnZ8F5JrYYZZ0WWmA2r42g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Uv++AnLtGnniFK5YSTNIX9gVqOtVjJDGfby40Lq4zqDeDFWbXVarO/ZyLtNcLBNCc
	 Z2eLUo0Iot+3Fv90Wbf434Zu9XeYIpgkxXj9vxSqD7/l23smbMGi7vh7KEPga6TCD9
	 WOcxsAi+bUb94xioBJoxRw34s2ptPSqJUgXgm8hI=
Date: Fri, 25 Sep 2026 16:23:53 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: "Benjamin Robin (Schneider Electric)" <benjamin.robin@bootlin.com>
Cc: stable@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, miguel.gazquez@bootlin.com,
	thomas.petazzoni@bootlin.com, rcu@vger.kernel.org,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH 6.18.y 1/2] rculist: add list_splice_rcu() for private
 lists
Message-ID: <2026092540-jokester-certify-1339@gregkh>
References: <20260925-cve-2026-52988-6-18-v1-0-680b24895415@bootlin.com>
 <20260925-cve-2026-52988-6-18-v1-1-680b24895415@bootlin.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925-cve-2026-52988-6-18-v1-1-680b24895415@bootlin.com>

On Fri, Sep 25, 2026 at 09:52:23AM +0200, Benjamin Robin (Schneider Electric) wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [ Upstream commit f902877b635551513729bdf9a8d1422c4aab7741 ]
> 
> This patch adds a helper function, list_splice_rcu(), to safely splice
> a private (non-RCU-protected) list into an RCU-protected list.
> 
> The function ensures that only the pointer visible to RCU readers
> (prev->next) is updated using rcu_assign_pointer(), while the rest of
> the list manipulations are performed with regular assignments, as the
> source list is private and not visible to concurrent RCU readers.
> 
> This is useful for moving elements from a private list into a global
> RCU-protected list, ensuring safe publication for RCU readers.
> Subsystems with some sort of batching mechanism from userspace can
> benefit from this new function.
> 
> The function __list_splice_rcu() has been added for clarity and to
> follow the same pattern as in the existing list_splice*() interfaces,
> where there is a check to ensure that the list to splice is not
> empty. Note that __list_splice_rcu() has no documentation for this
> reason.
> 
> Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/linux/rculist.h | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)

You did not sign off on this commit :(

