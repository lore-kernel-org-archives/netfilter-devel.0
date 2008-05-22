From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 0/2] Security: Add security tables for mandatory access
 control
Date: Thu, 22 May 2008 17:57:53 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0805221756520.9332@fbirervta.pbzchgretzou.qr>
References: <Xine.LNX.4.64.0805220008510.3033@us.intercode.com.au> <alpine.LNX.1.10.0805212359590.15136@fbirervta.pbzchgretzou.qr> <Xine.LNX.4.64.0805220842570.8393@us.intercode.com.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Paul Moore <paul.moore@hp.com>,
	Stephen Smalley <sds@tycho.nsa.gov>
To: James Morris <jmorris@namei.org>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <Xine.LNX.4.64.0805220842570.8393@us.intercode.com.au>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Thursday 2008-05-22 00:43, James Morris wrote:
>On Thu, 22 May 2008, Jan Engelhardt wrote:
>> On Wednesday 2008-05-21 16:17, James Morris wrote:
>> >
>> >In a nutshell, the need for this arises from the fact that MAC labe=
ling=20
>> >rules utilizing iptables via SECMARK and CONNSECMARK are not subjec=
t to=20
>> >discretionary security policy (i.e. not even "root" or a user with=20
>> >CAP_NET_ADMIN may be able to modify these rules).
>>=20
>> Yet I do not see any code to possibly prohibit changing the table.
>
>There are calls from SECMARK and CONNSECMARK into the SELinux API, whi=
ch=20
>are the labeling targets.

But you cannot deny the deletion of a rule from within SECMARK=E2=80=94
there is not even a ->destroy function in that module.
--
To unsubscribe from this list: send the line "unsubscribe linux-securit=
y-module" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
