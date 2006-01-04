From: Patrick McHardy <kaber@trash.net>
Subject: Re: ip_queue module issue
Date: Wed, 04 Jan 2006 08:13:19 +0100
Message-ID: <43BB758F.4020409@trash.net>
References: <002301c61010$3fa46f60$455f030a@askeyrd3>
	<43BA74FD.9030205@trash.net>
	<002c01c610d4$a04e3930$455f030a@askeyrd3>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: lartc@mailman.ds9a.nl,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <lartc-bounces@mailman.ds9a.nl>
To: Salim <salim.si@askey.com.tw>
In-Reply-To: <002c01c610d4$a04e3930$455f030a@askeyrd3>
List-Unsubscribe: <http://mailman.ds9a.nl/cgi-bin/mailman/listinfo/lartc>,
	<mailto:lartc-request@mailman.ds9a.nl?subject=unsubscribe>
List-Archive: <http://mailman.ds9a.nl/pipermail/lartc>
List-Post: <mailto:lartc@mailman.ds9a.nl>
List-Help: <mailto:lartc-request@mailman.ds9a.nl?subject=help>
List-Subscribe: <http://mailman.ds9a.nl/cgi-bin/mailman/listinfo/lartc>,
	<mailto:lartc-request@mailman.ds9a.nl?subject=subscribe>
Sender: lartc-bounces@mailman.ds9a.nl
Errors-To: lartc-bounces@mailman.ds9a.nl
List-Id: netfilter-devel.vger.kernel.org

Salim wrote:
> it does work when iptables as a whole is built as a module.

Do you use any patches that might register as queue handler,
like IMQ? Otherwise please check your logs for messages from
ip_queue during boot time, it should have logged the reason
if registration failed.
