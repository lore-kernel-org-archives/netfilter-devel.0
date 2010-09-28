From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH 3/6] secmark: export binary yes/no rather than kernel
 internal secid
Date: Tue, 28 Sep 2010 09:45:03 +0100
Message-ID: <4CA1AB0F.908@googlemail.com>
References: <20100924204517.28355.42822.stgit@paris.rdu.redhat.com>  <20100924204531.28355.20320.stgit@paris.rdu.redhat.com>  <alpine.LRH.2.00.1009271038280.25748@tundra.namei.org>  <1285606896.2815.36.camel@localhost.localdomain>  <1285612156.4935.16.camel@sifl> <1285615525.2815.76.camel@localhost.localdomain> <4CA11F36.2090705@netfilter.org> <alpine.LNX.2.01.1009280156170.5607@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Eric Paris <eparis@redhat.com>, Paul Moore <paul.moore@hp.com>,
	James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
	selinux@tycho.nsa.gov, netfilter-devel@vger.kernel.org,
	sds@tycho.nsa.gov, casey@schaufler-ca.com,
	linux-security-module@vger.kernel.org, netfilter@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.01.1009280156170.5607@obet.zrqbmnf.qr>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


>> In netlink, we can obsolete fields without breaking backward
>> compatibility. Applications parsing the /proc entry may break, but they
>> should use stable interfaces (like netlink) instead.
>>     
>
> Which I take as a pro stance on not adding any more procfs fields.
>   
How did you figure that one out then?

