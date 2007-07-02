From: "NICOLAS BOULIANE" <nicboul@gmail.com>
Subject: Re: [PATCH] libipt_statistic
Date: Mon, 2 Jul 2007 14:38:05 -0500
Message-ID: <dd45289d0707021238i7394ace5g552d8c170f0cb78d@mail.gmail.com>
References: <dd45289d0707011710v189ac25j174458fecb0bfb41@mail.gmail.com>
	<4688F979.60606@trash.net>
	<dd45289d0707020751j6bb5de27k25bc73e4337c818b@mail.gmail.com>
	<46891294.9030405@trash.net>
	<dd45289d0707021038p42e1871n200d2c425d50797c@mail.gmail.com>
	<4689387A.4050207@trash.net>
	<dd45289d0707021105q6b70c23m45135e0a56ccb5aa@mail.gmail.com>
	<46894116.9000203@trash.net>
	<dd45289d0707021210s53005cbfodff90f97f6ed69da@mail.gmail.com>
	<46894E8C.4070306@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_87349_17257321.1183405085240"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46894E8C.4070306@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

------=_Part_87349_17257321.1183405085240
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 7/2/07, Patrick McHardy <kaber@trash.net> wrote:
> NICOLAS BOULIANE wrote:
> > Now the pattern make sense :)
> > thank you Patrick,
> >
> > I'll write a patch for the upperbound
> > We can also specify --packet without --every,
> > side effectly --every will be set to 1, should be fix that too I think.
>
>
> Sounds reasonable.
>
> >
> > have some suggestions before a begin ?
>
> No :)
>
>
>

Signed-off-by: Nicolas Bouliane

comments are welcome,
thanks

------=_Part_87349_17257321.1183405085240
Content-Type: text/x-patch; name=libipt_statistic.c.patch;
	charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f3ncpyox
Content-Disposition: attachment; filename="libipt_statistic.c.patch"

SW5kZXg6IGxpYmlwdF9zdGF0aXN0aWMuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaWJpcHRfc3RhdGlzdGlj
LmMJKHJldmlzaW9uIDY4OTgpCisrKyBsaWJpcHRfc3RhdGlzdGljLmMJKHdvcmtpbmcgY29weSkK
QEAgLTExMyw2ICsxMTMsMTUgQEAKIAlpZiAoZmxhZ3MgJiAweDggJiYgaW5mby0+bW9kZSAhPSBY
VF9TVEFUSVNUSUNfTU9ERV9OVEgpCiAJCWV4aXRfZXJyb3IoUEFSQU1FVEVSX1BST0JMRU0sCiAJ
CQkgICAiLS1wYWNrZXQgY2FuIG9ubHkgYmUgdXNlZCBpbiBudGggbW9kZSIpOworCWlmICgoZmxh
Z3MgJiAweDgpICYmICEoZmxhZ3MgJiAweDQpKQorCQlleGl0X2Vycm9yKFBBUkFNRVRFUl9QUk9C
TEVNLAorCQkJICAgIi0tcGFja2V0IGNhbiBvbmx5IGJlIHVzZWQgd2l0aCAtLWV2ZXJ5Iik7CisJ
LyogYXQgdGhpcyBwb2ludCwgaW5mby0+dS5udGguZXZlcnkgaGF2ZSBiZWVuIGRlY3JlYXNlZC4g
Ki8KKwlpZiAoIShpbmZvLT51Lm50aC5wYWNrZXQgPj0gMCAmJiBpbmZvLT51Lm50aC5wYWNrZXQg
PD0gaW5mby0+dS5udGguZXZlcnkpKQorCQlleGl0X2Vycm9yKFBBUkFNRVRFUl9QUk9CTEVNLAor
CQkJICAidGhlIC0tcGFja2V0IHAgbXVzdCBiZSAwIDw9IHAgPD0gbi0xIik7CisKKwogCWluZm8t
PnUubnRoLmNvdW50ID0gaW5mby0+dS5udGguZXZlcnkgLSBpbmZvLT51Lm50aC5wYWNrZXQ7CiB9
CiAK
------=_Part_87349_17257321.1183405085240--
