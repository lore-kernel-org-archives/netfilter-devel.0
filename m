From: "Anton VG" <anton.vazir@gmail.com>
Subject: Re: SVN ULOG2
Date: Thu, 10 Apr 2008 13:19:20 +0500
Message-ID: <c4b050a10804100119m488a00a1hee1c3a2768ea736d@mail.gmail.com>
References: <200804091520.28617.anton.vazir@gmail.com>
	 <47FCA1F6.2000204@netfilter.org>
	 <200804091624.19125.anton.vazir@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_27212_713234.1207815560492"
Cc: "Netfilter Developer Mailing List" <netfilter-devel@vger.kernel.org>
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.185]:50897 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762AbYDJITW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Apr 2008 04:19:22 -0400
Received: by mu-out-0910.google.com with SMTP id i10so3998742mue.5
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Apr 2008 01:19:20 -0700 (PDT)
In-Reply-To: <200804091624.19125.anton.vazir@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

------=_Part_27212_713234.1207815560492
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

One more issue (though not sure is I did not miss something in configuration)

Trying to do Postgresql logging. Postgres 8.3
This is the entry, ulogd fails initializing on.

Thu Apr 10 18:02:26 2008 <7> ulogd.c:699 cannot find key
`mac.saddr.str' in stack
Thu Apr 10 18:02:26 2008 <1> ulogd.c:831 destroying stack
Thu Apr 10 18:02:26 2008 <8> ulogd.c:1084 not even a single working plugin stack

If I do syslog logging - ulogd atleast starts.

Full ulog.log is attached.

2008/4/9, Anton <anton.vazir@gmail.com>:
> On Wednesday 09 April 2008 16:01, Pablo Neira Ayuso wrote:
>
>  > As you said, it's under development but any help in
>  > testing and bugreporting would be great.
>
>
> Will be glad to help atleast this way!
>
>  Regards,
>
> Anton.
>  --
>  To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

------=_Part_27212_713234.1207815560492
Content-Type: application/x-bzip2; name=ulogd.log.bz2
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fev267sd
Content-Disposition: attachment; filename=ulogd.log.bz2

QlpoOTFBWSZTWUQi/s0ACnJfgAAQQOX/97///uD/7//gUAW87BN6BLWDVZtQoGSaTSegjKfqnima
g0abUNA0AB6gNGg5oyYmACYjAjTAgxGCZMAjBJqSRk0U9NJ+qNP1RoGgAA09Q0ADQBFJGhNNT9Ua
m1PTU9IPUGTRoPUYmno0h6TTEEUiZAJlNpoqfqntKeoAB6gGQBoHoisROiOrLIFLKmqJJEdGzXUt
cNkimjaqLJUXMqLGdUXDXirjuVF1TPvu/vjwBTF6sczIqLFFGEP8yQrHw6+ajgCQ5CSBjz7eW3Jv
/mdJwCQ8SSYlFLmAuE07s9D5COzNSyMA6/Z5FAIarwCRUSuH4XcIx7wJBO06Av3evwyoLGxXuvis
wU3AEjNLgmlm0nDl/brmjkiiVZscWoLbar9Cpd/VhZ2xamKi2a+FrU0AkDlByEEaUACISahCiZ7W
I2vYZW6poqofidCC1pDZjURxpLQ2qtzMgBxoAiG0WoiFhJh3gEmefg06b8Otv3mYYQ49f7SoBI3c
qiLIqq3FAIgiJxHC0FgsIpwCTiglwMmmIgKyC/0ZpaQFeX4fb8e5UXnVFmCmAKeSotxXMQPWalnR
UW9IVFoUKGh+QiOHtG1UXDUl6ou4qLM7VyhZZYJFyXXAKUvUrVF8RLRU3hI5rxLahB8l2JUXGlYy
rSaos+aqK528X1xKi8KUVFgQXGMiDdVFzEem5Iqz3QJYKlIBXj6gU/V4dgoQqL4ZImIEqV8hbzhy
QPfIgUPewcuzaQPTb2jAmvAw/ynEiOwyb5vkp5d8ditIKksL/WiOJO4S2P8xKRoTCBpfBgMpm6nn
mYk7Fpa2ApL2B3WHREc5jnI1NDHQUMZwIjnGfe+HAbg+CovdS8oOfoDUHEEwDsMgpBGAsk7bJor1
SoHtFPzervDmA2lnzxF4KawQ6ZApQwTTj2lPEAtED2d/Z5tn7kQfgHSZTNUWWQKTN452gSF0vFLg
zPThzAbAuqYQPEQWcpBYerFMAv5Xmo2hsmlDm8OiqTp1iCIjaoWghBWQXAYW1B1h8/ViFwGQk8XL
hjQ/M17GhI4BbbYS3IBSQTEApoQBqFhIUXijaJXYvBSC4wLbjJhRQYiHmkhJ0AvynH61VVVVWIiN
AugiyupXtkCllTbjuSDqpfEUqRHgcOqdMJDDO6TYzOud17N2SqqqqqtiuHHQQ4G6HLKREpQlxOZp
ZbKUufmUl7fu413Im2PTIdNZii6EbyQ2TxHCzCFwFMC8rUtokmUGWTEis08O9R0lWFroux1KAYAp
Kdc5yoSvLABNoaMDVJJJedILy+F5fBN3RVVVVXSb8wU7+4C8oGhIqdQUzPHYOxTiaB4HIJUWwUJY
RCwlgRlKlEsUSg1TqBtyDbtJGjfEQREb+Souo09hCcdoDQTvAwM1RcAUomKQHQI7Ap1qYiWZlAlG
AneYYXFaWlAMa8bgUsKOG1gITxIoeMpESyLEwBTpK9FMnubg6GKKWlRKZCVTyC7MLG01mrYwUomN
pDPJVVVVVVVumJmSuC/ZwIYL0sCiWoToStoQm5IO9UWhxcsoiI8EfHrkKLyzCNAUyDeDFKxYQl3h
NJicu6JkFpbzJ0ziK5GoU/8XckU4UJBEIv7N
------=_Part_27212_713234.1207815560492--
