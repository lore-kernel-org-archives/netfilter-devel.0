From: "=?ISO-8859-1?Q?Damien_Th=E9bault?=" <damien.thebault@gmail.com>
Subject: Re: conntrack doesn't always work when a bridge is used
Date: Thu, 20 Dec 2007 09:30:39 +0100
Message-ID: <9a4a382a0712200030w5502c312k33b330e03e0e8555@mail.gmail.com>
References: <9a4a382a0712180648i7fc958edt6f0d9db83f574c77@mail.gmail.com>
	 <9a4a382a0712190900v2ba747a0wd4ff243d0e65e9ef@mail.gmail.com>
	 <47696AE9.6090201@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-net@vger.kernel.org, netfilter-devel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <linux-net-owner@vger.kernel.org>
In-Reply-To: <47696AE9.6090201@trash.net>
Content-Disposition: inline
Sender: linux-net-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Dec 19, 2007 8:03 PM, Patrick McHardy <kaber@trash.net> wrote:
>
> Could you capture the conntrack events of the non-working
> case with (run in parallel):
>
> conntrack -E
> conntrack -E expect
>

Sure, here it is :

conntrack -E :

    [NEW] tcp      6 120 SYN_SENT src=192.168.1.5 dst=192.168.2.250
sport=45090 dport=21 [UNREPLIED] src=192.168.2.50 dst=192.168.2.70
sport=21 dport=45090
 [UPDATE] tcp      6 60 SYN_RECV src=192.168.1.5 dst=192.168.2.250
sport=45090 dport=21 src=192.168.2.50 dst=192.168.2.70 sport=21
dport=45090
 [UPDATE] tcp      6 432000 ESTABLISHED src=192.168.1.5
dst=192.168.2.250 sport=45090 dport=21 src=192.168.2.50
dst=192.168.2.70 sport=21 dport=45090 [ASSURED]
    [NEW] tcp      6 120 SYN_SENT src=127.0.0.1 dst=127.0.0.1
sport=47496 dport=631 [UNREPLIED] src=127.0.0.1 dst=127.0.0.1
sport=631 dport=47496
 [UPDATE] tcp      6 120 CLOSE src=127.0.0.1 dst=127.0.0.1 sport=47496
dport=631 src=127.0.0.1 dst=127.0.0.1 sport=631 dport=47496
[DESTROY] tcp      6 src=127.0.0.1 dst=127.0.0.1 sport=47496 dport=631
packets=1 bytes=60 src=127.0.0.1 dst=127.0.0.1 sport=631 dport=47496
packets=0 bytes=0
    [NEW] tcp      6 120 SYN_SENT src=192.168.2.50 dst=192.168.2.70
sport=20 dport=33344 [UNREPLIED] src=192.168.1.5 dst=192.168.2.250
sport=33344 dport=20
 [UPDATE] tcp      6 60 SYN_RECV src=192.168.2.50 dst=192.168.2.70
sport=20 dport=33344 src=192.168.1.5 dst=192.168.2.250 sport=33344
dport=20
 [UPDATE] tcp      6 432000 ESTABLISHED src=192.168.2.50
dst=192.168.2.70 sport=20 dport=33344 src=192.168.1.5
dst=192.168.2.250 sport=33344 dport=20 [ASSURED]
 [UPDATE] tcp      6 120 FIN_WAIT src=192.168.2.50 dst=192.168.2.70
sport=20 dport=33344 src=192.168.1.5 dst=192.168.2.250 sport=33344
dport=20 [ASSURED]
 [UPDATE] tcp      6 60 CLOSE_WAIT src=192.168.2.50 dst=192.168.2.70
sport=20 dport=33344 src=192.168.1.5 dst=192.168.2.250 sport=33344
dport=20 [ASSURED]
 [UPDATE] tcp      6 10 CLOSE src=192.168.2.50 dst=192.168.2.70
sport=20 dport=33344 src=192.168.1.5 dst=192.168.2.250 sport=33344
dport=20 [ASSURED]
 [UPDATE] tcp      6 120 FIN_WAIT src=192.168.1.5 dst=192.168.2.250
sport=45090 dport=21 src=192.168.2.50 dst=192.168.2.70 sport=21
dport=45090 [ASSURED]
 [UPDATE] tcp      6 60 CLOSE_WAIT src=192.168.1.5 dst=192.168.2.250
sport=45090 dport=21 src=192.168.2.50 dst=192.168.2.70 sport=21
dport=45090 [ASSURED]
 [UPDATE] tcp      6 30 LAST_ACK src=192.168.1.5 dst=192.168.2.250
sport=45090 dport=21 src=192.168.2.50 dst=192.168.2.70 sport=21
dport=45090 [ASSURED]
 [UPDATE] tcp      6 120 TIME_WAIT src=192.168.1.5 dst=192.168.2.250
sport=45090 dport=21 src=192.168.2.50 dst=192.168.2.70 sport=21
dport=45090 [ASSURED]
 [UPDATE] tcp      6 10 CLOSE src=192.168.1.5 dst=192.168.2.250
sport=45090 dport=21 src=192.168.2.50 dst=192.168.2.70 sport=21
dport=45090 [ASSURED]
    [NEW] unknown  2 600 src=192.168.1.1 dst=224.0.0.1 [UNREPLIED]
src=224.0.0.1 dst=192.168.1.1
[DESTROY] tcp      6 src=192.168.2.50 dst=192.168.2.70 sport=20
dport=33344 packets=4 bytes=559 src=192.168.1.5 dst=192.168.2.250
sport=33344 dport=20 packets=4 bytes=216
[DESTROY] tcp      6 src=192.168.1.5 dst=192.168.2.250 sport=45090
dport=21 packets=17 bytes=916 src=192.168.2.50 dst=192.168.2.70
sport=21 dport=45090 packets=12 bytes=1162

conntrack -E expect :

300 proto=6 src=192.168.2.50 dst=192.168.2.70 sport=0 dport=33344

-- 
Damien Thebault
