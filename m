From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH] tcp: unify tcp flag macros
Date: Sat, 12 Jun 2010 17:21:09 +0800
Message-ID: <AANLkTikZSn5zJYNPU2mdcBiyY7jfBOvq0f1khlbue4JD@mail.gmail.com>
References: <1276322372-12584-1-git-send-email-xiaosuo@gmail.com>
	<alpine.LSU.2.01.1006121017380.28286@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "David S. Miller" <davem@davemloft.net>,
	Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
	"Pekka Savola (ipv6)" <pekkas@netcore.fi>,
	James Morris <jmorris@namei.org>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <alpine.LSU.2.01.1006121017380.28286@obet.zrqbmnf.qr>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sat, Jun 12, 2010 at 4:18 PM, Jan Engelhardt <jengelh@medozas.de> wr=
ote:
>
> On Saturday 2010-06-12 07:59, Changli Gao wrote:
>>--- a/include/net/tcp.h
>>+++ b/include/net/tcp.h
>>@@ -602,6 +602,17 @@ extern u32 =A0 =A0 =A0 =A0__tcp_select_window(st=
ruct sock *sk);
>> =A0*/
>> #define tcp_time_stamp =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0((__u32)(jiffi=
es))
>>
>>+#define tcp_flag_byte(th) (((u_int8_t *)th)[13])
>>+
>>+#define =A0 =A0 =A0 TH_FIN =A00x01
>>+#define =A0 =A0 =A0 TH_SYN =A00x02
>>+#define =A0 =A0 =A0 TH_RST =A00x04
>>+#define =A0 =A0 =A0 TH_PUSH 0x08
>>+#define =A0 =A0 =A0 TH_ACK =A00x10
>>+#define =A0 =A0 =A0 TH_URG =A00x20
>>+#define =A0 =A0 =A0 TH_ECE =A00x40
>>+#define =A0 =A0 =A0 TH_CWR =A00x80
>
> I'd prefer something less generic, like TCPHDR_{FIN,SYN,etc}.
>
>

The same macros are definied by BSDs too. So I think it is better to
keep them the same.

--=20
Regards,
Changli Gao(xiaosuo@gmail.com)
