From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: TCP tracking states
Date: Sat, 6 Jul 2002 01:15:39 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200207060115.39594@henrik.marasystems.com>
References: <200207060038.59577@henrik.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel <netfilter-devel@lists.samba.org>
In-Reply-To: <200207060038.59577@henrik.marasystems.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Saturday 06 July 2002 00.38, Henrik Nordstrom wrote:

> To deal with 2, may I propose that the following symmetric FIN
> state machine is used instead of the odd assymetric one used today:
>
>
> ESTABLISHED / FIN  -> FIN_WAIT
>
> FIN_WAIT / ACK(R) -> CLOSE_WAIT
>
> CLOSE_WAIT / FIN(R) -> TIME_WAIT (or a new FIN_WAIT2 state)
>
> TIME_WAIT / ACK -> TIME_WAIT

On a second reflection it gets a little bit more complex than this. 
Need to keep track of which side has closed down, causing a small 
explosion in states...

FIN_WAIT_ORIGINAL
FIN_WAIT_REPLY
CLOSE_WAIT_ORIGINAL
CLOSE_WAIT_REPLY
FIN_WAIT2_ORIGINAL
FIN_WAIT2_REPLY
TIME_WAIT

State descriptions:

FIN_WAIT	-> Wait for ACK to FIN

CLOSE_WAIT	-> Wait for FIN in other direction



ESTABLISHED / FIN	-> FIN_WAIT_ORIGINAL

FIN_WAIT_ORIGINAL / ACK(R) -> CLOSE_WAIT_ORIGINAL

FIN_WAIT_ORIGINAL / FIN(R) -> FIN_WAIT2_ORIGINAL

CLOSE_WAIT_ORIGINAL / FIN(R) -> FIN_WAIT2_ORIGINAL

FIN_WAIT2_ORIGINAL / ACK -> TIME_WAIT


And identical in the other direction, s/ORIGINAL/REPLY/


Can be simplified by using TIME_WAIT for FIN_WAIT2_* if one likes, but 
isn't really fair if tuning is to be allowed for FIN_WAIT..

Regards
Henrik
