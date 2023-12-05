Received: from mail22.mail.schwarz (mail22.mail.schwarz [185.124.192.54])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F390BD3;
	Tue,  5 Dec 2023 01:39:58 -0800 (PST)
X-SCHWARZ-TO: coreteam@netfilter.org, netdev@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kadlec@netfilter.org, pablo@netfilter.org,
 linux-kernel@vger.kernel.org, davem@davemloft.net,
 netfilter-devel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 shuah@kernel.org, fw@strlen.de
X-SCHWARZ-ENVELOPEFROM: felix.huettner@mail.schwarz
Received: from felix.runs.onstackit.cloud ([45.129.43.133])
  by mail22.mail.schwarz with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 09:39:57 +0000
Date: Tue, 5 Dec 2023 09:39:56 +0000
From: Felix Huettner <felix.huettner@mail.schwarz>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kadlec@netfilter.org, fw@strlen.de,
	davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
	shuah@kernel.org, luca.czesla@mail.schwarz,
	max.lamprecht@mail.schwarz
Subject: Re: [PATCH net-next v2] net: ctnetlink: support filtering by zone
Message-ID: <ZW7v7NIvDxxYI+qv@felix.runs.onstackit.cloud>
References: <ZWSCPKtDuYRG1XWt@kernel-bug-kernel-bug>
 <ZWSNrlHYdp+URAy6@calendula>
 <ZWnD4SqjhHXmtXlR@kernel-bug-kernel-bug>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWnD4SqjhHXmtXlR@kernel-bug-kernel-bug>

Hi,

> > 
> > Please, extend libnetfilter_conntrack to support for this feature,
> > there is a filter API that can be used for this purpose.
> 
> I will do that and post it here (or in the next version) once i am done.
> 

A patch for this is now on netfilter-devel at [1].

[1]: https://marc.info/?l=netfilter-devel&m=170176886315385&w=2

Thanks
