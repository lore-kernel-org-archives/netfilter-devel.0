From: "Filip Sneppe (Cronos)" <filip.sneppe@cronos.be>
Subject: Re: MSN helper module
Date: 17 Dec 2002 23:38:21 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1040164701.893.42.camel@exile>
References: <200212171647.gBHGkxmD003537@sandelman.ottawa.on.ca>
	<002801c2a5fb$1eb92660$152ea8c0@maincomp> <1040161933.615.71.camel@exile>
	<001701c2a615$cc774dd0$152ea8c0@maincomp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Michael Richardson
	 <mcr@sandelman.ottawa.on.ca>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Carlos Fernandez Sanz <cfs-netfilter@nisupu.com>
In-Reply-To: <001701c2a615$cc774dd0$152ea8c0@maincomp>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

hi Carlos,

On Tue, 2002-12-17 at 22:46, Carlos Fernandez Sanz wrote:
> Thanks for the links. I have done some research already. I don't think it's
> going to be a weekend project but possibly not a lot more :-) Anyway I don't
> really have an option. It's starting to escalate...

Good to hear that we may have an additional netfilter module soon !

> BTW, when you started to work on this, did you take a look at the FTP
> module? I think it solves most of the problems (including security), since
> the connection method is identical to an active (PORT initiated) FTP data
> connection.

I think I heard Rusty explain how he dealt with this during some netfilter
talk, I think. IIRC, with ftp there are "end-of-line" markers before
or after the PORT/PASV commands that allow the module to distinguish
them from weird filenames in the control channel. That's the only
protection mechanism I heard of for the ftp conntrackers.

With MSN, it's a little trickier:

A normal messaging command looks like this:

MSG 3 A 157
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-MMS-IM-Format: FN=Microsoft%20Sans%20Serif; EF=I; CO=000000; CS=0;
PF=22

Hello! How are you? 


where the "157" is a length indicator (including header). Now the 157
bytes minus header that follow this can be anything: end-of-line
characters, and stuff that looks like "MSG 4 A 140<cr>".

What the module shouldn't do, is get confused by this "user-supplied"
content and start interpreting it. Otherwise, if a user supplied:

MSG 4 N 238
MIME-Version: 1.0
Content-Type: text/x-msmsgsinvite; charset=UTF-8

Invitation-Command: ACCEPT
Invitation-Cookie: 33267
IP-Address: 10.44.102.65
Port: 6891
AuthCookie: 93301
Launch-Application: FALSE
Request-Data: IP-Address:

as the content of a MSG message, it would create a security problem.

So I guess you need to do something like this:

- Parse the first data packet, assuming that you're not parsing
  a packet from a "messaging" session, because that could already
  contain spoofed data.
- If you encounter a "MSG 4 N xxx" message in the MSN header, check
  the rest of the header for the "Content-Type: text/x-msmsgsinvite"
  string. If that's present, it's an MSN file transfer request.
  go from there to add the expectation.
- If you encounter a "MSG 4 N xxx" message without the
  "Content-Type: text/x-msmsgsinvite" stuff in the MSN header,
  you should ignore the xxx bytes of that MSN packet (and possibly
  the following packets if xxx >> MTU) and not parse it at all:
  it's just user supplied data.
- I think you'll need to keep track of that MSG length field
  inside some ip_ct_msn_master to keep track of it accross
  various packets. I don't know if your module has to deal with
  out of order packets, ...
- Possibly you could do even stricter checking by watching the
  Invitation cookies etc.

Does this sound correct ?

Regards,
Filip
