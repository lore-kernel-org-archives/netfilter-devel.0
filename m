From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 8/8 v3] iptables: string extension case insensitive matching
Date: Mon, 07 Jul 2008 13:33:22 +0200
Message-ID: <4871FF02.8000100@trash.net>
References: <> <1215389675-19925-1-git-send-email-joonwpark81@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netdev <netdev@vger.kernel.org>,
	netfilter-devel <netfilter-devel@vger.kernel.org>,
	Thomas Graf <tgraf@suug.ch>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Engelhardt <jengelh@medozas.de>
To: Joonwoo Park <joonwpark81@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1215389675-19925-1-git-send-email-joonwpark81@gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Joonwoo Park wrote:
> The string extension can search patterns case insensitively with --icase
> option.
> A new revision 1 was added, in the meantime invert of xt_string_info was
> moved into flags as a flag.

Also applied, thanks.
