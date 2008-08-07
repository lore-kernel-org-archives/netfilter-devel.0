From: Denys Fedoryshchenko <denys@visp.net.lb>
Subject: Re: TCP connection stalls under 2.6.24.7
Date: Thu, 7 Aug 2008 15:23:03 +0300
Message-ID: <200808071523.04586.denys@visp.net.lb>
References: <47EA0DAB.7080205@securenet.de> <200808071450.43552.denys@visp.net.lb> <Pine.LNX.4.64.0808071454580.4551@wrl-59.cs.helsinki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "=?iso-8859-1?q?D=E2niel?= Fraga" <fragabr@gmail.com>,
	Thomas Jarosch <thomas.jarosch@intra2net.com>,
	Netdev <netdev@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>,
	Sven Riedel <sr@securenet.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	David Miller <davem@davemloft.net>
To: "Ilpo =?iso-8859-1?q?J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0808071454580.4551@wrl-59.cs.helsinki.fi>
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thursday 07 August 2008, Ilpo J=E4rvinen wrote:
>
> I could have still looked to it :-), I can mostly decide anything TCP
> congestion control related based on solely a tcpdump, and I can even =
read
> tcpdump -n -r logfile output if you want to fully hide any payloads (=
as
> long as the lines are not split to a mess in an email :-)) though the=
n
> plotting them is not as easy for me (I could hack my tool someday tho=
ugh
> to handle that as well).
I will try my best to reproduce it and report (sure on latest stable ke=
rnel).
On pre and git a bit more difficult but i will try also.

