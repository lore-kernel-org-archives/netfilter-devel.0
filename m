From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH][NETFILTER]: Net namespace leak when reading /proc/net/xxx_tables_names.
Date: Mon, 21 Apr 2008 17:09:41 +0200
Message-ID: <480CAE35.5050301@trash.net>
References: <480CAA15.6060003@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>,
	Linux Netdev List <netdev@vger.kernel.org>,
	Alexey Dobriyan <adobriyan@openvz.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pavel Emelyanov <xemul@openvz.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <480CAA15.6060003@openvz.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Pavel Emelyanov wrote:
> The seq_open_net() call should be accompanied with seq_release_net() one.
> 
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

Applied, thanks.
