From: =?ISO-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>
Subject: Re: TCP connection stalls under 2.6.24.7
Date: Thu, 10 Jul 2008 19:20:49 -0300
Message-ID: <1jeik5-68f.ln1@tux.abusar.org.br>
References: <200807101146.26034.thomas.jarosch@intra2net.com>
	<200807101251.30712.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 10 Jul 2008 12:51:30 +0200
Thomas Jarosch <thomas.jarosch@intra2net.com> wrote:

> We found a workaround by putting a linux-based AVM fritz!box router between 
> kernel 2.6.25.10 and the mailserver, now the TCP connection works again,
> though it gets NATed. Still can't make any sense out of this.

	I have the same problem with connections stalled and the only
"workaround" I found is to trigger a nmap -sS to the server with the
stalled connection. I don't know why, but this helps it come back alive
again...

	But it surely is a Linux network bug introduced in 2.6.25
kernel, I'm sure (with 2.6.24 and below it doesn't happen, or maybe
we're talking about different symptoms of the same bug or 2 different
similar bugs... who knows?).

	I use the tg3 kernel module for the NIC... the same
configuration of the kernel doesn't trigger the bug with other types of
nics... so could we suspect of tg3 kernel module?

	What's your NIC?

-- 
Linux 2.6.25: Funky Weasel is Jiggy wit it
http://u-br.net
Marilyn Manson - "Wrapped in Plastic" (Portrait of an American Family -
1994)


